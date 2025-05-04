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
      commitHashShort =
        if (builtins.hasAttr "shortRev" inputs.self) then
          inputs.self.shortRev
        else
          inputs.self.dirtyShortRev;
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

          # nix build
          # podman load < result
          # podman run --rm --network=host localhost/s6-overlay-example:latest
          default = pkgs.callPackage ./target/container {
            inherit nixpkgs;
            tag = commitHashShort;
          };
          machine =
            (pkgs.callPackage ./target/machine {
              nixpkgs = inputs.nixpkgs;
              microvm = inputs.microvm;
            }).config.microvm.declaredRunner;
        }
      );
    };
}
