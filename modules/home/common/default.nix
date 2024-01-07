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

    united = {
      btop.enable = true;
      fzf.enable = true;
      git.enable = true;
      gnupg.enable = true;
      net-utils.enable = true;
      ranger.enable = true;
      sops.enable = true;
      tmux.enable = true;
      user.enable = true;
      vim.enable = true;
      yubikey.enable = true;
      zsh.enable = true;
    };

    xdg.enable = true;
  };
}