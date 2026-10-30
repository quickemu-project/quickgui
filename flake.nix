{
  description = "Quickgui flake";
  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*.tar.gz";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    flutter-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/*.tar.gz";
    quickemu.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-schemas,
    nixpkgs,
    flutter-nixpkgs,
    quickemu,
  }: let
      # Define supported systems and a helper function for generating system-specific outputs
      #TODO: Add the following as quickemu/quickgui/GitHub builders support them:
      #      aarch64-darwin aarch64-linux x86_64-darwin
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        system = system;
        pkgs = import nixpkgs { inherit system; };
        flutter = (import flutter-nixpkgs { inherit system; }).flutter;
      });
  in {
    # Define schemas for the flake's outputs
    schemas = flake-schemas.schemas;

    # Define overlays for each supported system
    overlays = forEachSupportedSystem ({pkgs, system, flutter, ...}: {
      default = final: prev: {
        quickgui = final.callPackage ./package.nix { inherit flutter; quickemu = quickemu.packages.${system}.default; };
      };
    });

    # Define packages for each supported system
    packages = forEachSupportedSystem ({pkgs, system, flutter, ...}: rec {
      quickgui = pkgs.callPackage ./package.nix { inherit flutter; quickemu = quickemu.packages.${system}.default; };
      default = quickgui;
    });

    # Define devShells for each supported system
    devShells = forEachSupportedSystem ({pkgs, system, flutter, ...}: {
      default = pkgs.callPackage ./devshell.nix { inherit flutter; quickemu = quickemu.packages.${system}.default; };
    });
  };
}
