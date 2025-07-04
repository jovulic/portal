{
  pkgs,
  s6service,
  s6oneshot,
  timezone,
  user,
  dbus,
  ...
}:
let
  name = "weston";
  xdgRuntimeDir = "/run/user/nomad";
  waylandDisplay = "wayland-1";
  westonTlsKeyPath = "/etc/xdg/weston/key.pem";
  westonTlsCrtPath = "/etc/xdg/weston/crt.pem";
  westonIniPath = "/etc/xdg/weston/weston.ini";
  westonIniFile = pkgs.writeTextFile {
    name = "weston.ini";
    text = ''
      [core]
      idle-time=0

      [shell]
      panel-position=none
    '';
    destination = westonIniPath;
  };

  appName = "${name}-app";
  appService = s6service.build {
    name = appName;
    runScript = ''
      export XDG_RUNTIME_DIR ${xdgRuntimeDir}
      export DBUS_SESSION_BUS_ADDRESS "unix:path=${xdgRuntimeDir}/bus"
      export HOME ${user.users.nomad.env.HOME}
      s6-setuidgid ${user.users.nomad.name} weston \
        --renderer=pixman \
        --backend=rdp-backend.so \
        --address=0.0.0.0 \
        --port=3389 \
        --rdp-tls-key=${westonTlsKeyPath} \
        --rdp-tls-cert=${westonTlsCrtPath} \
        --config="${westonIniPath}"
    '';
    dependencies = [ dbus.service.name ];
  };
  dbusName = "${name}-dbus";
  dbusService = s6service.build {
    name = dbusName;
    runScript = ''
      export XDG_RUNTIME_DIR ${xdgRuntimeDir}
      s6-setuidgid ${user.users.nomad.name} dbus-daemon --session --nofork --address="unix:path=${xdgRuntimeDir}/bus"
    '';
    dependencies = [ dbus.service.name ];
  };
  ready = s6oneshot.build {
    inherit name;
    type = "oneshot";
    upScript = ''
      echo "weston ready"
    '';
    dependencies = [
      timezone.service.name
      appName
      dbusName
    ];
  };
in
{
  container = {
    root = {
      paths =
        [
          pkgs.weston
          pkgs.openssl
          westonIniFile
        ]
        ++ s6service.listFiles appService
        ++ s6service.listFiles dbusService
        ++ s6oneshot.listFiles ready;
      exec = ''
        echo "Setting up Weston..."

        # NB: It must be rsa:2048 otherwise you will see errors like so on
        # connection. "certificate is not RSA 2048, RDP security not
        # supported."
        openssl req -x509 -newkey rsa:2048 \
          -sha256 \
          -nodes \
          -days 3650 \
          -keyout ${westonTlsKeyPath} \
          -out ${westonTlsCrtPath} \
          -subj "/CN=weston.local"
        chmod 644 ${westonTlsKeyPath}

        mkdir -p "${xdgRuntimeDir}"
        chmod 700 "${xdgRuntimeDir}"
        chown ${user.users.nomad.name}:${user.users.nomad.name} "${xdgRuntimeDir}"
      '';
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
