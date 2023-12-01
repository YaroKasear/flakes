{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    chroma
    thefuck
    tinyfugue
  ];

  programs = {
    tmux = {
      enable = true;
      mouse = true;
      tmuxinator.enable = true;
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
      initExtra = ''
        export GPG_TTY="$(tty)"
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent
      '';
    };  
  };
}
