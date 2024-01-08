{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
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
        asciiquarium
        chroma
        cowsay
        fortune
        mosquitto
        neofetch
        nvd
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

    united = with config.united.user.colors; {
      btop.enable = true;
      fzf.enable = true;
      git.enable = true;
      gnupg.enable = true;
      net-utils.enable = true;
      sops.enable = true;
      tmux.enable = true;
      vim.enable = true;
      yubikey.enable = true;
      zsh.enable = true;
      user = {
        enable = true;
        colors = {
          visual_bell_color = "#bfe0ff";
          active_tab_background = "#0dc9c9";
          active_border_color = active_tab_background;
          inactive_tab_background = "#197d60";
          inactive_tab_foreground = "#d0d0d0";
          inactive_border_color = inactive_tab_background;
          tab_bar_background = background;
          tab_bar_margin_color = background;
          selection_background = active_tab_background;
          selection_foreground = active_tab_foreground;
        };
      };
    };

    xdg.enable = true;
  };
}