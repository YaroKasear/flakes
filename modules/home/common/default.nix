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
        chroma
        cowsay
        fortune
        neofetch
        snowfallorg.flake
        sops
        thefuck
        (python3.withPackages(ps: with ps; [
          jinja2
          jupyter
          lxml
          pandas
          dbus-python
          pygobject3
        ]))
      ];
    };

    programs = {
      fzf.enable = true;
      home-manager.enable = true;
      nix-index.enable = true;
    };

    united = {
      btop.enable = true;
      git.enable = true;
      gnupg.enable = true;
      net-utils.enable = true;
      tmux.enable = true;
      user.enable = true;
      vim.enable = true;
      yubikey.enable = true;
      zsh.enable = true;
    };
  };
}