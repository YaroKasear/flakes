{ config, pkgs, ... }:

{

  imports = [
    ../common/cli.nix
  ];

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
    nerdfonts
    powerline-fonts
    yubioath-flutter
    (python3.withPackages(ps: with ps; [pandas jinja2]))
  ];

  programs = {
    firefox.enable = true;
    vscode.enable = true;
    nix-index.enable = true;
    autorandr = {
      enable = true;
      profiles = {
        "monitor" = {
          fingerprint = {
            DP-4 = "00ffffffffffff0010ace7a0555544302e1a0104a5351e7806ee91a3544c99260f505421080001010101010101010101010101010101565e00a0a0a02950302035000f282100001a000000ff0023415350757062706d6a5a5064000000fd001e9022de3b010a202020202020000000fc0044656c6c20533234313744470a01ca020312412309070183010000654b040001015a8700a0a0a03b50302035000f282100001a5aa000a0a0a04650302035000f282100001a6fc200a0a0a05550302035000f282100001a22e50050a0a0675008203a000f282100001e1c2500a0a0a01150302035000f282100001a0000000000000000000000000000000000000044";
          };
          config = {
            DP-4 = {
              enable = true;
              mode = "2560x1440";
              primary = true;
              rate = "144.00";
            };
          };
        };
      };
    };
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
          trust = 5;
        }
      ];
      settings = {
        no-greeting = true;
        throw-keyids = true;
      };
      scdaemonSettings = {
        disable-ccid = true;
      };
    };
  };
  services = {
    nextcloud-client.enable = true;
    autorandr.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      extraConfig = ''
        ttyname $GPG_TTY
      '';
    };
  };

  pam.yubico.authorizedYubiKeys.ids = [
    "ccccccvvktff"
  ];

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
