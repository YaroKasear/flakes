{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    chroma
    thefuck
    mpvScripts.mpris
    neofetch
    fortune
    neo-cowsay
    tinyfugue
  ];

  programs = {
    mpv = {
      enable = true;
      scripts = with pkgs; [
        mpvScripts.mpris
      ];
    };
    tmux = {
      enable = true;
      mouse = true;
      tmuxinator.enable = true;
    };
    vim = {
      enable = true;
      defaultEditor = true;
    };
    fzf = {
      enable = true;
    };
    kitty = {
      enable = true;
      font.name = "FiraCode Nerd Font";
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        theme = "jonathan";
        plugins = [
          "aliases"
          "colored-man-pages"
          "colorize"
          "command-not-found"
          "common-aliases"
          "copypath"
          "dircycle"
          "emoji"
          "emoji-clock"
          "extract"
          "fzf"
          "git"
          "gnu-utils"
          "isodate"
          "lol"
          "man"
          "python"
          "safe-paste"
          "sudo"
          "thefuck"
          "themes"
          "tmux"
          "tmuxinator"
          "vscode"
          "web-search"
          "zsh-navigation-tools"
        ];
      };
      shellAliases = {
        icat = "kitten icat";
        update-config = "sudo nixos-rebuild switch --flake /home/yaro/flakes#";
      };
      initExtra = ''
        neofetch
        fortune -a | cowsay --random --aurora --bold -n
      '';
    };
  };
}
