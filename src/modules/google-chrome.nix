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
        --no-default-browser-check
    '';
    dependencies = [
      weston.service.name
      dbus.service.name
    ];
  };
in
{
  container = {
    root = {
      paths = [
        pkgs.google-chrome
      ] ++ s6service.listFiles service;
      exec = '''';
    };
  };
  service = {
    inherit name;
  };
}
