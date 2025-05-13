{
  pkgs,
  s6service,
  weston,
  dbus,
  ...
}:
let
  name = "google-chrome";
  service = s6service.build {
    inherit name;
    # TODO: I should pull the runtime and display values from the weston
    # expression. Or figure how to expose this via s6-overlay.
    runScript = ''
      export XDG_RUNTIME_DIR /tmp/xdg-wayland
      export WAYLAND_DISPLAY wayland-1
      google-chrome-stable \
        --ozone-platform=wayland \
        --no-sandbox \
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
