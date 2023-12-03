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
    sonic3air = {
      url = "./custom/sonic3air";
    };
  };  

  outputs = { self, nixpkgs, home-manager, nix-index-database, sops-nix, sonic3air, ... }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [sonic3air.overlay];
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
                  sops-nix.homeManagerModules.sops
                  ./loki/home.nix
                ];
              };
            }
            sops-nix.nixosModules.sops
          ];
	      };
      };
    };
}

