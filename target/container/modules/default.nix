{ pkgs, ... }:
{
  s6 = pkgs.callPackage ./s6.nix { };
}
