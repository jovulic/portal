{
  pkgs,
  s6oneshot,
  ...
}:
let
  name = "timezone";
  zoneinfo = pkgs.stdenv.mkDerivation {
    pname = "tzdata-zoneinfo";
    version = pkgs.tzdata.version;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/usr/share
      ln -s ${pkgs.tzdata}/share/zoneinfo $out/usr/share/zoneinfo
    '';
  };
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
        zoneinfo
      ] ++ s6oneshot.listFiles oneshot;
      exec = '''';
    };
  };
  service = {
    inherit name;
  };
}
