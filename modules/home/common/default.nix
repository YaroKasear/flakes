{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  cfg = config.united.common;
in {
  options.united.common = {
    enable = mkEnableOption "Common";
  };

  config = mkIf cfg.enable {
    home = {
      stateVersion = "23.11";
      packages = with pkgs;
      let
        cowsay = inputs.cowsay.packages.${system}.cowsay;
      in [
        age
        chroma
        cowsay
        file
        fortune
        killall
        mosquitto
        neofetch
        nvd
        p7zip
        snowfallorg.flake
        sops
        thefuck
        unzip
        (python3.withPackages(ps: with ps; [
          dbus-python
          jinja2
          jupyter
          lxml
          pandas
          pillow
          pygobject3
        ]))
      ];
    };

    programs = {
      home-manager.enable = true;
      nix-index.enable = true;
    };

    united = {
      asciiquarium.enable = true;
      bat.enable = true;
      btop.enable = true;
      eza.enable = true;
      fzf.enable = true;
      git.enable = true;
      gnupg.enable = true;
      net-utils.enable = true;
      sops.enable = is-linux;
      tmux.enable = true;
      nixvim.enable = false;
      vim.enable = true;
      yubikey.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
      user = {
        enable = true;
        directories = {
          documents = "${config.united.user.directories.home}/Personal Cloud/Documents";
          games = "/mnt/games";
          music = "/mnt/music";
          pictures = "/mnt/pictures";
          screenshots = "${config.united.user.directories.home}/Pictures/Screenshots";
          wallpapers = "${config.united.user.directories.home}/Pictures/Wallpapers";
          videos = "/mnt/videos";
        };
      };
      style = with config.united.style; {
        enable = true;
        catppuccin.frappe.enable = true;
        effects.shadow = {
          active-color = config.united.style.colors.active_border_color;
          inactive-color = config.united.style.colors.inactive_border_color;
          offsetX = 0;
          offsetY = 0;
          spread = 20;
        };
      };
    };

    xdg.enable = true;
  };
}