{ pkgs, ... }:
let
  s6OverlayNoarch =
    let
      version = "3.2.0.2";
    in
    pkgs.fetchurl {
      url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-noarch.tar.xz";
      sha256 = "sha256-bbzeFYo+eLm7FB17y1zLQh5WNSO6u+LGRHDnb0/QLa4=";
    };

  s6OverlayArch =
    let
      version = "3.2.0.2";
      arch = "x86_64";
    in
    pkgs.fetchurl {
      url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-${arch}.tar.xz";
      sha256 = "sha256-WSiUVqsXYeJ3vUVqlec3wGsD7emRWL6yTxKxZakE9Hg=";
    };
in
{
  container = {
    root = {
      paths = [
        pkgs.busybox
        pkgs.execline
        pkgs.s6
      ];
      exec = ''
        mkdir -p /run /var
        ln -s /run /var/run

        tar -C / -xf ${s6OverlayNoarch}
        tar -C / -xf ${s6OverlayArch}
      '';
    };
    config = {
      path = "/command";
    };
  };
  buildService =
    { name, text }:
    pkgs.writeTextFile {
      inherit name;
      text = ''
        #!${pkgs.execline}/bin/execlineb -P
        ${text}
      '';
      destination = "/etc/services.d/${name}/run";
      executable = true;
    };
}
