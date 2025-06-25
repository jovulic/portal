{
  pkgs,
  lib,
  version,
  commitHashShort,
  ...
}:

let
  modules = pkgs.callPackage ./modules { };
  mergeContainerPaths = mods: lib.concatLists (lib.map (mod: mod.container.root.paths) mods);
  concatContainerExecs =
    mods: lib.concatStringsSep "\n" (lib.map (mod: mod.container.root.exec) mods);
in
pkgs.dockerTools.buildImage {
  name = "portal";
  tag = "${version}-${commitHashShort}";
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
        modules.timezone
        modules.user
        modules.weston
        modules.dbus
        modules.fonts
        modules.google-chrome
      ];
    pathsToLink = [
      "/bin"
      "/sbin"
      "/usr"
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
      modules.timezone
      modules.user
      modules.weston
      modules.dbus
      modules.fonts
      modules.google-chrome
    ])
  ];

  config = {
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/jovulic/portal";
    };
    ExposedPorts = {
      "9222/tcp" = { };
      "3389/tcp" = { };
    };
    Env = [
      "PATH=${modules.s6.container.config.path}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      "TZ=Etc/UTC"
    ];
    Entrypoint = [ "/init" ];
  };
}
