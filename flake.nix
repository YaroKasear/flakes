{
  description = "The United Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur.url = github:nix-community/NUR;

    cowsay = {
      url = "github:snowfallorg/cowsay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    player-mpris-tail = {
      url = "https://raw.githubusercontent.com/polybar/polybar-scripts/master/polybar-scripts/player-mpris-tail/player-mpris-tail.py";
      flake = false;
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ranger-devicons = {
      url = "github:alexanderjeurissen/ranger_devicons";
      flake = false;
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpaper-generator = {
      url = "github:pinpox/wallpaper-generator";
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
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
      ];

      systems = {
        modules.nixos = with inputs; [
          nix-gaming.nixosModules.pipewireLowLatency
          nixos-hardware.nixosModules.common-pc
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
        ];
        hosts.loki.modules = with inputs; [
          nix-gaming.nixosModules.steamCompat
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
        hosts.iso.modules = with inputs; [
          nixos-generators.nixosModules.all-formats
        ];
      };

      homes.users = {
        "yaro@loki".modules = with inputs; [
          nix-index-database.hmModules.nix-index
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@Gwyn".modules = with inputs; [
          nix-index-database.hmModules.nix-index
          sops-nix.homeManagerModules.sops
        ];
      };
    };
}

