{ pkgs, ... }:

let
  modules = pkgs.callPackage ./modules { };
in
pkgs.dockerTools.buildImage {
  name = "s6-overlay-example";
  tag = "latest";
  created = "now";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [
      pkgs.dockerTools.usrBinEnv
      pkgs.dockerTools.binSh
      pkgs.dockerTools.caCertificates
      pkgs.coreutils
      pkgs.bashInteractive
      (modules.s6.buildService {
        name = "hello";
        text = ''
          echo "Hello world!"
        '';
      })
    ] ++ modules.s6.container.root.paths;
    pathsToLink = [
      "/bin"
      "/sbin"
      "/usr/bin"
      "/usr/sbin"
      "/etc"
    ];
  };

  runAsRoot = modules.s6.container.root.exec;

  config = {
    Env = [
      "PATH=${modules.s6.container.config.path}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    ];
    Entrypoint = [ "/init" ];
  };
}
