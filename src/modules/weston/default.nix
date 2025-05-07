{ pkgs, s6service, ... }:
# The following was used to generate the tls certificates.
# openssl req -x509 -newkey rsa:4096 \
#   -sha256 \
#   -nodes \
#   -days 3650 \
#   -keyout key.pem \
#   -out crt.pem \
#   -subj "/CN=weston.local"
let
  xdgRuntimeDir = "/tmp/xdg-wayland";
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
    name = "weston";
    runScript = ''
      export XDG_RUNTIME_DIR ${xdgRuntimeDir}
      weston --backend=rdp-backend.so \
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
        mkdir -p "${xdgRuntimeDir}"
        chmod 700 "${xdgRuntimeDir}"
      '';
    };
  };
}
