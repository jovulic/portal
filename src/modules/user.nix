{ pkgs, ... }:
let
  root = "root";
  nomad = "nomad";
  etcPasswdFile = pkgs.writeTextFile {
    name = "etc-passwd";
    text = ''
      ${root}:x:0:0:${root}:/${root}:/bin/sh
      ${nomad}:!:1001:1001:${nomad}:/home/${nomad}:/bin/sh
    '';
    destination = "/etc/passwd";
  };
  etcGroupFile = pkgs.writeTextFile {
    name = "etc-group";
    text = ''
      ${root}:x:0:
      ${nomad}:x:1001:
    '';
    destination = "/etc/group";
  };
  etcShadowFile = pkgs.writeTextFile {
    name = "etc-shadow";
    text = ''
      ${root}:*:19700:0:99999:7:::
      ${nomad}:*:19700:0:99999:7:::
    '';
    destination = "/etc/shadow";
  };
in
{
  container = {
    root = {
      paths = [
        pkgs.shadow
        etcPasswdFile
        etcGroupFile
        etcShadowFile
      ];
      exec = ''
        mkdir -p /${root}

        mkdir -p /home/${nomad}
        chown ${nomad}:${nomad} /home/${nomad}
      '';
    };
  };
  users = {
    "${root}" = {
      name = root;
      env = {
        HOME = "/${root}";
      };
    };
    "${nomad}" = {
      name = nomad;
      env = {
        HOME = "/home/${nomad}";
      };
    };
  };
}
