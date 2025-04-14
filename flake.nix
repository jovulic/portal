{
  description = "A containerized browser with remote access.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      inherit (inputs) nixpkgs;
      inherit (inputs.nixpkgs) lib;
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      eachSystem =
        f:
        lib.genAttrs systems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            inherit system;
          }
        );
    in
    {
      devShells = eachSystem (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.git
              pkgs.bash
              pkgs.podman
            ];
          };
        }
      );
      packages = eachSystem (
        { pkgs, ... }:
        {
          machine =
            (pkgs.callPackage ./dev {
              nixpkgs = inputs.nixpkgs;
              microvm = inputs.microvm;
            }).config.microvm.declaredRunner;
        }
      );
    };
}
