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
      atuin.enable = true;
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
      user.enable = true;
    };

    xdg.enable = true;
  };
}