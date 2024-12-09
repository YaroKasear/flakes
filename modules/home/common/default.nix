{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.common;

in
{
  options.united.common = {
    enable = mkEnableOption "Common";
  };

  config = mkIf cfg.enable {
    home = {
      stateVersion = "24.11";
      packages = with pkgs;
        let
          cowsay = inputs.cowsay.packages.${system}.cowsay;
        in
        [
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
      nix-index = enabled;
    };

    united = {
      bat = enabled;
      btop = enabled;
      eza = enabled;
      fzf = enabled;
      gnupg = enabled;
      tmux = enabled;
      nixvim = enabled;
      starship = enabled;
      user = enabled;
      vim = disabled;
      yubikey = enabled;
      zellij = enabled;
      zoxide = enabled;
      zsh = enabled;
    };

    xdg = enabled;
  };
}
