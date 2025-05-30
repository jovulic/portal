{ pkgs, ... }:
let
  root = "root";
  nomad = "nomad";
  etcPasswdFilePath = "/etc/passwd";
  etcGroupFilePath = "/etc/group";
  etcShadowFilePath = "/etc/shadow";
in
{
  container = {
    root = {
      paths = [
        pkgs.shadow
      ];
      exec = ''
        mkdir -p /etc

        cat > ${etcPasswdFilePath} <<EOF
        ${root}:x:0:0:${root}:/${root}:/bin/nologin
        ${nomad}:x:1001:1001:${nomad}:/home/${nomad}:/bin/sh
        EOF
        chmod 0644 ${etcPasswdFilePath}

        cat > ${etcGroupFilePath} <<EOF
        ${root}:x:0:
        ${nomad}:x:1001:
        EOF
        chmod 0644 ${etcGroupFilePath}

        cat > ${etcShadowFilePath} <<EOF
        ${root}:*:19700:0:99999:7:::
        ${nomad}:*:19700:0:99999:7:::
        EOF
        chmod 0600 ${etcShadowFilePath}

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
