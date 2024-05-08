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
        chroma
        cowsay
        file
        fortune
        killall
        fastfetch
        p7zip
        thefuck
        unzip
      ];
    };

    programs = {
      home-manager = {
        enable = true;
      };
      nix-index.enable = true;
    };

    united = {
      bat.enable = true;
      btop.enable = true;
      eza.enable = true;
      fzf.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      nixvim.enable = true;
      starship.enable = true;
      sops.enable = mkDefault true;
      user.enable = true;
      vim.enable = false;
      yubikey.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };

    xdg.enable = true;
  };
}