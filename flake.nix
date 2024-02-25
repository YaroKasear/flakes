{
  description = "The United Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur.url = github:nix-community/NUR;

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cowsay = {
      url = "github:snowfallorg/cowsay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-swaync-latte = {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.1.2.1/latte.css";
      flake = false;
    };

    catppuccin-swaync-frappe = {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.1.2.1/frappe.css";
      flake = false;
    };

    catppuccin-swaync-mocha = {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.1.2.1/mocha.css";
      flake = false;
    };

    catppuccin-swaync-macchiato = {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.1.2.1/macchiato.css";
      flake = false;
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    polybar-scripts = {
      url = "github:polybar/polybar-scripts";
      flake = false;
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
        home-manager.useGlobalPkgs = true;
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
      ];

      systems = {
        modules.nixos = with inputs; [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          nix-gaming.nixosModules.pipewireLowLatency
          nix-gaming.nixosModules.steamCompat
          nixos-hardware.nixosModules.common-pc
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
        ];
        hosts.loki.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
        hosts.loki-xorg.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
        hosts.experimental.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
      };

      homes.users = {
        "yaro@loki".modules = with inputs; [
          ags.homeManagerModules.default
          hyprland.homeManagerModules.default
          impermanence.nixosModules.home-manager.impermanence
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@titan".modules = with inputs; [
          ags.homeManagerModules.default
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@europa".modules = with inputs; [
          ags.homeManagerModules.default
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@io".modules = with inputs; [
          ags.homeManagerModules.default
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@loki-xorg".modules = with inputs; [
          ags.homeManagerModules.default
          hyprland.homeManagerModules.default
          impermanence.nixosModules.home-manager.impermanence
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@Gwyn".modules = with inputs; [
          ags.homeManagerModules.default
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
      };
    };
}

