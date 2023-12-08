{ config, pkgs, lib, ... }:

{
  imports = [
    ./gui.nix
    ../common/accounts.nix
    ../common/programs/kitty.nix
    ../common/programs/mpv.nix
    ../common/programs/git.nix
    ../common/programs/thunderbird.nix
    ../common/programs/tmux.nix
    ../common/programs/vim.nix
    ../common/programs/zsh.nix
    ../common/yubikey.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yaro";
  home.homeDirectory = "/home/yaro";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    rsync
    nerdfonts
    powerline-fonts
    sops
    chroma
    thefuck
    mpvScripts.mpris
    neofetch
    fortune
    neo-cowsay
    tinyfugue
    skypeforlinux
    discord
    mattermost-desktop
    telegram-desktop
    bitwarden
    rsync
    dex
    libreoffice-fresh
    playerctl
    virt-manager
    dotnet-runtime
    steam-run
    dunst
    diffuse
    (python3.withPackages(ps: with ps; [pandas jinja2 lxml jupyter]))
  ];

  home = {
    file = {
      layout = {
        source = ../files/i3/layout.json;
        target = ".config/i3/layout.json";
      };
    };
  };

  programs = {
    fzf.enable = true;
    nix-index.enable = true;
    firefox.enable = true;
    vscode.enable = true;
    rofi.enable = true;
    i3status.enable = true;
  };

  services = {
    nextcloud-client.enable = true;
    autorandr.enable = true;
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
