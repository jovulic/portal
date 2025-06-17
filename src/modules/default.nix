{ pkgs, ... }:
let
  s6 = pkgs.callPackage ./s6 { };
  s6service = pkgs.callPackage ./s6/service.nix { };
  s6oneshot = pkgs.callPackage ./s6/oneshot.nix { };
  timezone = pkgs.callPackage ./timezone.nix { inherit s6oneshot; };
  user = pkgs.callPackage ./user.nix { };
  dbus = pkgs.callPackage ./dbus.nix { inherit s6service; };
  weston = pkgs.callPackage ./weston {
    inherit
      s6service
      s6oneshot
      timezone
      user
      dbus
      ;
  };
  fonts = pkgs.callPackage ./fonts.nix { };
  google-chrome = pkgs.callPackage ./google-chrome.nix {
    inherit
      s6service
      user
      weston
      dbus
      ;
  };
in
{
  inherit s6;
  inherit timezone;
  inherit user;
  inherit dbus;
  inherit weston;
  inherit fonts;
  inherit google-chrome;
}
