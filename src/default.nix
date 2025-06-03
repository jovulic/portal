{ pkgs, lib, ... }:

let
  modules = pkgs.callPackage ./modules { };
  mergeContainerPaths = mods: lib.concatLists (lib.map (mod: mod.container.root.paths) mods);
  concatContainerExecs =
    mods: lib.concatStringsSep "\n" (lib.map (mod: mod.container.root.exec) mods);
in
pkgs.dockerTools.buildImage {
  name = "waypoint";
  tag = "latest"; # TODO: replace with version/commit
  created = "now";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths =
      [
        pkgs.dockerTools.usrBinEnv
        pkgs.dockerTools.binSh
        pkgs.dockerTools.caCertificates
        pkgs.util-linux
        pkgs.coreutils
        pkgs.bashInteractive
      ]
      ++ mergeContainerPaths [
        modules.s6
        modules.user
        modules.weston
        modules.dbus
        modules.fonts
        modules.google-chrome
      ];
    pathsToLink = [
      "/bin"
      "/sbin"
      "/usr/bin"
      "/usr/sbin"
      "/etc"
    ];
  };

  runAsRoot = lib.concatStringsSep "\n" [
    ''
      mkdir -p /tmp
      chmod 1777 /tmp
    ''
    (concatContainerExecs [
      modules.s6
      modules.user
      modules.weston
      modules.dbus
      modules.fonts
      modules.google-chrome
    ])
  ];

  config = {
    Env = [
      "PATH=${modules.s6.container.config.path}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    ];
    Entrypoint = [ "/init" ];
  };
}
