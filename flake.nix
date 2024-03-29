{
  description = "The United Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nur.url = github:nix-community/NUR;

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

    hyprcatppuccin-frappe-dark = {
      url = "https://github.com/entailz/hyprcatppuccin/raw/master/hyprconverted/extracted_Catppuccin-Frappe-Dark-Cursors.tar.gz";
      flake = false;
    };

    hyprcatppuccin-latte-blue = {
      url = "https://github.com/entailz/hyprcatppuccin/raw/master/hyprconverted/extracted_Catppuccin-Latte-Blue-Cursors.tar.gz";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
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

    nix-rice .url = "github:bertof/nix-rice";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-stable = {
      url = "github:nix-community/nixvim/nixos-23.11";
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
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
          # hyprlock.nixosModules.hyprlock
          impermanence.nixosModules.impermanence
          nix-gaming.nixosModules.pipewireLowLatency
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
        ];
        hosts.loki.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
        hosts.loki-xorg.modules = with inputs; [
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
      };

      homes.users = {
        "yaro@loki".modules = with inputs; [
          hyprland.homeManagerModules.default
          impermanence.nixosModules.home-manager.impermanence
          hyprlock.homeManagerModules.default
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "cnelson@loki".modules = with inputs; [
          hyprland.homeManagerModules.default
          impermanence.nixosModules.home-manager.impermanence
          hyprlock.homeManagerModules.default
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@titan".modules = with inputs; [
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@europa".modules = with inputs; [
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@io".modules = with inputs; [
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@loki-xorg".modules = with inputs; [
          hyprland.homeManagerModules.default
          hyprlock.homeManagerModules.default
          impermanence.nixosModules.home-manager.impermanence
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          nur.hmModules.nur
          sops-nix.homeManagerModules.sops
        ];
        "yaro@Gwyn".modules = with inputs; [
          nix-index-database.hmModules.nix-index
          nixvim.homeManagerModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
      };
    };
}

