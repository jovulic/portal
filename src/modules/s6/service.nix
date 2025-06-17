# documentation: https://skarnet.org/software/s6-rc/s6-rc-compile.html
{ pkgs, lib, ... }:
{
  build =
    {
      name,
      type ? "longrun",
      runScript,
      finishScript ? ''
        if test "$1" -eq 256 ; then
          err=$((128 + $2))
        else
          err="$1"
        fi
        echo "$err" > /run/s6-linux-init-container-results/exitcode
      '',
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

      # The "run" file defines what should be executed when the service starts.
      #
      # NB: The pipeline, fdmove, and sed are there to write a prefix to the
      # service logs so we know which service is emitting which logs.
      run = pkgs.writeTextFile {
        name = "${name}-run";
        text = ''
          #!${pkgs.execline}/bin/execlineb -P
          pipeline { 
            fdmove -c 2 1 ${runScript}
          } sed "s/^/[${name}] /"
        '';
        destination = "/etc/s6-overlay/s6-rc.d/${name}/run";
        executable = true;
      };

      # The "finish" file defines what should be executed when the service exits.
      finish =
        if finishScript != null then
          pkgs.writeTextFile {
            name = "${name}-finish";
            text = ''
              #!${pkgs.bash}/bin/bash
              ${finishScript}
            '';
            destination = "/etc/s6-overlay/s6-rc.d/${name}/finish";
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
