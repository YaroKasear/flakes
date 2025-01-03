{
  description = "The United Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    argon40-nix = {
      url = "github:guusvanmeerveld/argon40-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blocklist = {
      url = "github:mirosval/unbound-blocklist";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cowsay = {
      url = "github:snowfallorg/cowsay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-zsh-highlighing = {
      url = "github:catppuccin/zsh-syntax-highlighting";
      flake = false;
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-rice.url = "github:bertof/nix-rice";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "united-flake";
          title = "The United Flake";
        };
        namespace = "united";
        package-namespace = "united";
      };

      package-namespace = "united";

      channels-config = {
        allowUnfree = true;
        home-manager = {
          useGlobalPkgs = true;
        };
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
        agenix-rekey.overlays.default
      ];

      agenix-rekey = inputs.agenix-rekey.configure {
        userFlake = inputs.self;
        nodes = inputs.self.nixosConfigurations;
      };

      systems = {
        modules.nixos = with inputs; [
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
          blocklist.nixosModules.default
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          nix-gaming.nixosModules.pipewireLowLatency
          nur.modules.nixos.default
          lix-module.nixosModules.default
          nix-minecraft.nixosModules.minecraft-servers
        ];
        hosts.loki.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
        hosts.phobos.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc
        ];
        hosts.deimos.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc
        ];
        hosts.silvanus.modules = with inputs; [
          argon40-nix.nixosModules.default
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };

      homes.users =
        let
          home-modules = with inputs; [
            impermanence.nixosModules.home-manager.impermanence
            nix-index-database.hmModules.nix-index
            nixvim.homeManagerModules.nixvim
            nur.modules.homeManager.default
            plasma-manager.homeManagerModules.plasma-manager
          ];
        in
        {
          "cnelson@loki".modules = home-modules;
          "yaro@deimos".modules = home-modules;
          "yaro@europa".modules = home-modules;
          "yaro@io".modules = home-modules;
          "yaro@loki".modules = home-modules;
          "yaro@gwyn".modules = home-modules;
          "yaro@gwynix".modules = home-modules;
          "yaro@phobos".modules = home-modules;
          "yaro@silvanus".modules = home-modules;
        };
    };
}

