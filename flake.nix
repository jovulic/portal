{
  description = "A containerized browser with remote access.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
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
            shellHook = ''
              timezone=$(readlink -f /etc/localtime | sed 's/\/.*zoneinfo\///')
              export TZ="$timezone"
            '';
          };
        }
      );
      packages = eachSystem (
        { pkgs, ... }:
        {
          default = pkgs.callPackage ./src {
            inherit nixpkgs;
            tag = commitHashShort;
          };
        }
      );
      apps = eachSystem (
        { pkgs, ... }:
        let
          createApp = text: {
            type = "app";
            program = "${
              pkgs.writeShellApplication {
                name = "script";
                inherit text;
              }
            }/bin/script";
          };
        in
        {
          default = createApp ''
            podman load < "$(nix build --print-out-paths)"
            podman run -e TZ="$TZ" --rm --network=host -it localhost/waypoint:latest /bin/sh
          '';
        }
      );
    };
}
