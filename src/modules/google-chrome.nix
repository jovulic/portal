{
  pkgs,
  s6service,
  user,
  weston,
  dbus,
  ...
}:
let
  name = "google-chrome";
  service = s6service.build {
    inherit name;
    runScript = ''
      export XDG_RUNTIME_DIR ${weston.runtime.env.XDG_RUNTIME_DIR}
      export WAYLAND_DISPLAY ${weston.runtime.env.WAYLAND_DISPLAY}
      export HOME ${user.users.nomad.env.HOME}
      export DBUS_SESSION_BUS_ADDRESS "unix:path=${weston.runtime.env.XDG_RUNTIME_DIR}/bus"
      s6-setuidgid ${user.users.nomad.name} google-chrome-stable \
        --ozone-platform=wayland \
        --disable-gpu \
        --disable-software-rasterizer \
        --disable-dev-shm-usage \
        --disable-extensions \
        --disable-background-networking \
        --disable-default-apps \
        --disable-renderer-backgrounding \
        --start-fullscreen \
        --no-first-run \
        --no-default-browser-check \
        --remote-debugging-port=9222
    '';
    dependencies = [
      weston.service.name
      dbus.service.name
    ];
  };
  googleChromeReadyFile = pkgs.writeTextFile {
    name = "google-chrome-ready";
    text = ''
      check_chrome_ready() {
        curl -s http://127.0.0.1:9222/json/version > /dev/null
        return $?
      }

      echo "waiting for chrome devtools protocol to be ready..."
      until check_chrome_ready; do
        echo "chrome is not ready. retrying in 1 second..."
        sleep 1
      done
      echo "chrome is ready!"
    '';
    destination = "/bin/google-chrome-ready";
    executable = true;
  };
in
{
  container = {
    root = {
      paths = [
        pkgs.google-chrome
        pkgs.curl
        googleChromeReadyFile
      ] ++ s6service.listFiles service;
      exec = '''';
    };
  };
  service = {
    inherit name;
  };
}
