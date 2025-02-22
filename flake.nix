{
  # Based on https://github.com/fmoda3/nix-configs/blob/master/flake.nix
  description = "Tucker Lein's nix configuration";
  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    # Environment/system management
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other sources
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nightly-overlay = {
      # Don't follow nixpkgs for this, so that binary cache can be used.
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };
  outputs = inputs@{ self, nixpkgs, darwin, flake-parts, ... }:
    let
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.neovim-nightly-overlay.overlays.default
          # "pkgs" currently points to unstable
          # The following overlay allows you to specify "pkgs.stable" for stable versions
          # and "pkgs.master" for versions on master
          (
            final: prev:
              let
                inherit (prev.stdenv) system;
                nixpkgs-stable = if system == "x86_64-darwin" || system == "aarch64-darwin" then nixpkgs-stable-darwin else nixos-stable;
              in
              {
                master = nixpkgs-master.legacyPackages.${system};
                stable = nixpkgs-stable.legacyPackages.${system};
              }
          )
          # Add in custom defined packages in the pkgs directory
          (
            final: prev: { flake = self; } // import ./pkgs final prev
          )
        ];
      };
      darwinModules = { user, host }: with inputs; [
        # Main `nix-darwin` config
        (./. + "/hosts/${host}/configuration.nix")
        # `home-manager` module
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          # Pins channels and flake registry to use the same nixpkgs as this flake.
          nix.registry = nixpkgs.lib.mapAttrs (_: value: { flake = value; }) inputs;
          # `home-manager` config
          users.users.${user}.home = "/Users/${user}";
          home-manager = {
            useGlobalPkgs = true;
            users.${user} = import (./. + "/hosts/${host}/home.nix");
            sharedModules = [
            ];
          };
        }
      ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];
      flake = {
        darwinConfigurations = {
          macos-personal-laptop = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = darwinModules {
              user = "tucker";
              host = "macos-personal-laptop";
            };
            specialArgs = { inherit inputs nixpkgs; };
          };
        };
      };
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells.default = {
        };
      };
    };
}
