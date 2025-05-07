{ pkgs, ... }:
let
  s6 = pkgs.callPackage ./s6 { };
  s6service = pkgs.callPackage ./s6/service.nix { };
  weston = pkgs.callPackage ./weston { inherit s6service; };
in
{
  inherit s6;
  inherit weston;
}
