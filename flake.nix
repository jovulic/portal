{
  description = "A collection of hello world nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
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
            pkgs = nixpkgs.legacyPackages.${system};
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
              pkgs.bashly
            ];
          };
        }
      );
      packages = eachSystem (
        { pkgs, ... }:
        {
          default =
            let
              commitHashShort =
                if (builtins.hasAttr "shortRev" inputs.self) then
                  inputs.self.shortRev
                else
                  inputs.self.dirtyShortRev;
            in
            {
            };
        }
      );
    };
}
