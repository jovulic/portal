{ pkgs, s6service, ... }:
let

  dbusSystemConf = pkgs.writeText "dbus-system.conf" ''
    <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>
      <type>system</type>
      <listen>unix:path=/run/dbus/system_bus_socket</listen>
      <auth>EXTERNAL</auth>
      <policy context="default">
        <allow send_destination="*" eavesdrop="true"/>
        <allow receive_sender="*" eavesdrop="true"/>
        <allow own="*"/>
        <allow user="*"/>
      </policy>
    </busconfig>
  '';
  dbus = pkgs.dbus.overrideAttrs (
    _: _: {
      postInstall = ''
        cp ${dbusSystemConf} $out/etc/dbus-1/system.conf
      '';
    }
  );

  name = "dbus";
  service = s6service.build {
    inherit name;
    runScript = ''
      # The dbus-daemon needs /run/dbus to exist and be writable. The --nofork
      # option is important for process supervision by s6.
      dbus-daemon --system --nofork
    '';
  };
in
{
  container = {
    root = {
      paths = [
        dbus
        pkgs.shadow
      ] ++ s6service.listFiles service;
      exec = ''
        echo "Setting up D-Bus..."

        echo "Ensuring D-Bus directories and machine-id exist..."
        mkdir -p /run/dbus /var/lib/dbus
        if [ ! -s /var/lib/dbus/machine-id ]; then
          echo "Generating /var/lib/dbus/machine-id"
          dbus-uuidgen --ensure=/var/lib/dbus/machine-id
        else
          echo "/var/lib/dbus/machine-id already exists."
        fi
        if [ ! -L /etc/machine-id ] || [ "$(readlink /etc/machine-id)" != "/var/lib/dbus/machine-id" ]; then
          echo "Linking /etc/machine-id to /var/lib/dbus/machine-id"
          ln -fs /var/lib/dbus/machine-id /etc/machine-id
        else
          echo "/etc/machine-id is already correctly linked."
        fi
      '';
    };
  };
  service = {
    inherit name;
  };
}
