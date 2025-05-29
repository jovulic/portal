{
  pkgs,
  s6service,
  user,
  ...
}:
# The following was used to generate the tls certificates.
#
# openssl req -x509 -newkey rsa:2048 \
#   -sha256 \
#   -nodes \
#   -days 3650 \
#   -keyout key.pem \
#   -out crt.pem \
#   -subj "/CN=weston.local"
#
# NB: It must be rsa:2048 otherwise you will see errors like so on connection.
# "certificate is not RSA 2048, RDP security not supported."
let
  name = "weston";
  xdgRuntimeDir = "/tmp/xdg-wayland";
  waylandDisplay = "wayland-1";
  westonTlsKeyFile = "/etc/weston/key.pem";
  westonTlsCrtFile = "/etc/weston/crt.pem";
  tlsKeyFile = pkgs.writeTextFile {
    name = "key.pem";
    text = builtins.readFile ./+key.pem;
    destination = westonTlsKeyFile;
  };
  tlsCrtFile = pkgs.writeTextFile {
    name = "crt.pem";
    text = builtins.readFile ./crt.pem;
    destination = westonTlsCrtFile;
  };
  service = s6service.build {
    inherit name;
    runScript = ''
      export HOME ${user.users.root.env.HOME}
      export XDG_RUNTIME_DIR ${xdgRuntimeDir}
      weston \
        --renderer=pixman \
        --backend=rdp-backend.so \
        --address=0.0.0.0 \
        --port=3389 \
        --rdp-tls-key=${westonTlsKeyFile} \
        --rdp-tls-cert=${westonTlsCrtFile}
    '';
  };
in
{
  container = {
    root = {
      paths = [
        pkgs.weston
        tlsKeyFile
        tlsCrtFile
      ] ++ s6service.listFiles service;
      exec = ''
        echo "Setting up Weston..."

        mkdir -p "${xdgRuntimeDir}"
        chmod 700 "${xdgRuntimeDir}"
      '';
    };
    config = {
      env = [
        "XDG_RUNTIME_DIR=${xdgRuntimeDir}"
        "WAYLAND_DISPLAY=${waylandDisplay}"
      ];
    };
  };
  service = {
    inherit name;
  };
  runtime = {
    env = {
      XDG_RUNTIME_DIR = xdgRuntimeDir;
      WAYLAND_DISPLAY = waylandDisplay;
    };
  };
}
