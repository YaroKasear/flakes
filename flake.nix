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
  };  

  outputs = { self, nixpkgs, home-manager, nix-index-database, ... }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        loki = lib.nixosSystem {
          inherit system;
          modules = [
            ./loki/config.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yaro = {
                imports = [
                  nix-index-database.hmModules.nix-index
                  ./loki/home.nix
                ];
              };
            }
          ];
	};
      };
      hmConfig = {
        loki = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # pkgs = pkgs;
          modules = [
            ./loki/home.nix
          ];
        };
      };
    };
}

