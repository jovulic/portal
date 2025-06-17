# documentation: https://skarnet.org/software/s6-rc/s6-rc-compile.html
{ pkgs, lib, ... }:
{
  build =
    {
      name,
      type ? "oneshot",
      upScript,
      downScript ? null,
      dependencies ? [ ],
    }:
    lib.filterAttrs (_: attrValue: attrValue != null) {
      # The "user" file marks the service as part of the user bundle (to be run
      # with the container).
      user = pkgs.writeTextFile {
        name = "${name}-user";
        text = "";
        destination = "/etc/s6-overlay/s6-rc.d/user/contents.d/${name}";
      };

      # The "type" file defines the way the service runs. Usually longrun, but
      # oneshot is an option too.
      type = pkgs.writeTextFile {
        name = "${name}-type";
        text = type;
        destination = "/etc/s6-overlay/s6-rc.d/${name}/type";
      };

      # The "down" file defines what should be executed when the oneshot starts.
      up = pkgs.writeTextFile {
        name = "${name}-up";
        text = ''
          #!${pkgs.execline}/bin/execlineb -P
          pipeline { 
            fdmove -c 2 1 ${upScript}
          } sed "s/^/[${name}] /"
        '';
        destination = "/etc/s6-overlay/s6-rc.d/${name}/up";
        executable = true;
      };

      # The "down" file defines what should be executed when the oneshot exits.
      down =
        if downScript != null then
          pkgs.writeTextFile {
            name = "${name}-down";
            text = ''
              #!${pkgs.execline}/bin/execlineb -P
              pipeline { 
                fdmove -c 2 1 ${downScript}
              } sed "s/^/[${name}] /"
            '';
            destination = "/etc/s6-overlay/s6-rc.d/${name}/down";
            executable = true;
          }
        else
          null;

      # A "dependency" file defines the order that services should be started.
      dependencies = lib.listToAttrs (
        map (
          depName:
          lib.nameValuePair depName (
            pkgs.writeTextFile {
              name = "${name}-${depName}-dependency";
              text = "";
              destination = "/etc/s6-overlay/s6-rc.d/${name}/dependencies.d/${depName}";
            }
          )
        ) dependencies
      );
    };
  listFiles =
    service:
    let
      # Get the top-level derivations, minus dependencies as we need to
      # navigate one level down to get all the text files.
      tops = lib.attrValues (lib.filterAttrs (name: _: name != "dependencies") service);
      deps = lib.attrValues service.dependencies;
    in
    tops ++ deps;
}
