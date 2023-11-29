{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yaro";
  home.homeDirectory = "/home/yaro";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    thunderbird
    skypeforlinux
    discord
    mattermost-desktop
    telegram-desktop
    bitwarden
    tinyfugue
    chroma
    rsync
    thefuck
    nerdfonts
    powerline-fonts
    (python3.withPackages(ps: with ps; [pandas jinja2]))
  ];

  programs = {
    firefox.enable = true;
    vscode.enable = true;
    git = {
      enable = true;
      userName = "Yaro Kasear";
      userEmail = "yarokasear@gmail.com";
    };
    gpg = {
      enable = true;
      publicKeys = [
        {
          source = ../yaro-key.asc;
        }
      ];
    };
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
    };
  };
  services = {
    nextcloud-client.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yaro/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
