{
  pkgs,
  s6service,
  ...
}:
let
  name = "dbus";

  dbusSystemConf = pkgs.writeText "dbus-system.conf" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <busconfig>
      <type>system</type>
      <pidfile>/run/dbus/pid</pidfile>
      <auth>EXTERNAL</auth>
      <listen>unix:path=/run/dbus/system_bus_socket</listen>

      <policy context="default">
        <allow user="*"/>
        <deny own="*"/>
        <deny send_type="method_call"/>
        <allow send_type="signal"/>
        <allow send_requested_reply="true" send_type="method_return"/>
        <allow send_requested_reply="true" send_type="error"/>
        <allow receive_type="method_call"/>
        <allow receive_type="method_return"/>
        <allow receive_type="error"/>
        <allow receive_type="signal"/>
        <allow send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus"/>
        <allow send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus.Introspectable"/>
        <allow send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus.Properties"/>
        <allow send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus.Containers1"/>
        <deny send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus" send_member="UpdateActivationEnvironment"/>
        <deny send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus.Debug.Stats"/>
        <deny send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.systemd1.Activator"/>
      </policy>

      <policy user="root">
        <allow send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.systemd1.Activator"/>
        <allow send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus.Monitoring"/>
        <allow send_destination="org.freedesktop.DBus" send_interface="org.freedesktop.DBus.Debug.Stats"/>
      </policy>
    </busconfig>
  '';
  dbusSessionConf = pkgs.writeText "dbus-session.conf" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <busconfig>
      <type>session</type>
      <keep_umask/>
      <listen>unix:tmpdir=/tmp</listen>
      <auth>EXTERNAL</auth>
      <standard_session_servicedirs/>
      <policy context="default">
        <allow send_destination="*" eavesdrop="true"/>
        <allow eavesdrop="true"/>
        <allow own="*"/>
      </policy>

      <limit name="max_incoming_bytes">1000000000</limit>
      <limit name="max_incoming_unix_fds">250000000</limit>
      <limit name="max_outgoing_bytes">1000000000</limit>
      <limit name="max_outgoing_unix_fds">250000000</limit>
      <limit name="max_message_size">1000000000</limit>
      <limit name="service_start_timeout">120000</limit>  
      <limit name="auth_timeout">240000</limit>
      <limit name="pending_fd_timeout">150000</limit>
      <limit name="max_completed_connections">100000</limit>  
      <limit name="max_incomplete_connections">10000</limit>
      <limit name="max_connections_per_user">100000</limit>
      <limit name="max_pending_service_starts">10000</limit>
      <limit name="max_names_per_connection">50000</limit>
      <limit name="max_match_rules_per_connection">50000</limit>
      <limit name="max_replies_per_connection">50000</limit>
    </busconfig>
  '';
  dbus = pkgs.dbus.overrideAttrs (
    _: _: {
      postInstall = ''
        cp ${dbusSystemConf} $out/etc/dbus-1/system.conf
        cp ${dbusSessionConf} $out/etc/dbus-1/session.conf
      '';
    }
  );

  service = s6service.build {
    name = "${name}";
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
      ] ++ s6service.listFiles service;
      exec = ''
        echo "Setting up D-Bus..."

        mkdir -p /run/dbus

        mkdir -p /var/lib/dbus
        dbus-uuidgen --ensure=/etc/machine-id
        ln -s /etc/machine-id /var/lib/dbus/machine-id
      '';
    };
  };
  service = {
    inherit name;
  };
}
