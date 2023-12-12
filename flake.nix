{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };  

  outputs = { self, nixpkgs, home-manager, nix-index-database, sops-nix, nix-darwin, ... }: 
    let 
      pkgs = import nixpkgs {
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        loki = lib.nixosSystem {
        system = "x86_64-linux";
          modules = [
            ./loki/config.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yaro = {
                imports = [
                  nix-index-database.hmModules.nix-index
                  sops-nix.homeManagerModules.sops
                  ./loki/home.nix
                ];
              };
            }
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

