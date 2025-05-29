{ pkgs, ... }:
let
  s6 = pkgs.callPackage ./s6 { };
  s6service = pkgs.callPackage ./s6/service.nix { };
  user = pkgs.callPackage ./user.nix { };
  weston = pkgs.callPackage ./weston { inherit s6service user; };
  dbus = pkgs.callPackage ./dbus.nix { inherit s6service; };
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
  inherit user;
  inherit weston;
  inherit dbus;
  inherit fonts;
  inherit google-chrome;
}
