{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cowsay = {
      url = "github:snowfallorg/cowsay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpaper-generator = {
      url = "github:pinpox/wallpaper-generator";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-index-database, sops-nix, nix-darwin, nixos-hardware, ... }:
  {
    # specialArgs = { inherit inputs; };
    nixosConfigurations = {
      loki = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
        modules = [
          ./loki/config.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.yaro = {
              imports = [
                nix-index-database.hmModules.nix-index
                sops-nix.homeManagerModules.sops
                ./loki/home.nix
              ];
            };
          }
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          sops-nix.nixosModules.sops
        ];
      };
    };
    darwinConfigurations = {
      Gwyn = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./gwyn/config.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.yaro = {
              imports = [
                nix-index-database.hmModules.nix-index
                sops-nix.homeManagerModules.sops
                ./gwyn/home.nix
              ];
            };
          }
        ];
      };
    };

    darwinPackages = self.darwinConfigurations.Gwyn.pkgs;
    };
}

