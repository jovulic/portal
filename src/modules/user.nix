{ pkgs, ... }:
let
  etcPasswdFile = pkgs.writeTextFile {
    name = "etc-passwd";
    text = ''
      root:x:0:0:root:/root:/bin/sh
    '';
    destination = "/etc/passwd";
  };
  etcGroupFile = pkgs.writeTextFile {
    name = "etc-group";
    text = ''
      root:x:0:
    '';
    destination = "/etc/group";
  };
  etcShadowFile = pkgs.writeTextFile {
    name = "etc-shadow";
    text = ''
      root:*:19700:0:99999:7:::
    '';
    destination = "/etc/shadow";
  };
in
{
  container = {
    root = {
      paths = [
        etcPasswdFile
        etcGroupFile
        etcShadowFile
      ];
      exec = ''
        mkdir -p /root
        chmod 700 /root
      '';
    };
  };
}
