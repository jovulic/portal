{
  pkgs,
  s6oneshot,
  ...
}:
let
  name = "timezone";
  oneshot = s6oneshot.build {
    inherit name;
    type = "oneshot";
    upScript = ''
      with-contenv
      importas -si TZ TZ
      ln -sn "/usr/share/zoneinfo/''\${TZ}" /etc/localtime
    '';
  };
in
{
  container = {
    root = {
      paths = [
      ] ++ s6oneshot.listFiles oneshot;
      exec = ''
        echo "Setting up timezone..."

        # Setup timezone data.
        mkdir -p /usr/share
        ln -sf ${pkgs.tzdata.out}/share/zoneinfo /usr/share/zoneinfo
      '';
    };
  };
  service = {
    inherit name;
  };
}
