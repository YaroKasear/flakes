{ config, pkgs, lib, ... }:

{
  imports = [
    ../common/accounts.nix
    ../common/programs/autorandr.nix
    ../common/programs/git.nix
    ../common/programs/gpg.nix
    ../common/programs/kitty.nix
    ../common/programs/mpv.nix
    ../common/programs/thunderbird.nix
    ../common/programs/tmux.nix
    ../common/programs/vim.nix
    ../common/programs/zsh.nix
  ];

  home = {
    username = "yaro";
    homeDirectory = "/home/yaro";
    file = {
      layout = {
        source = ../files/i3/layout.json;
        target = ".config/i3/layout.json";
      };
    };
    packages = with pkgs; [
      bitwarden
      chroma
      dex
      diffuse
      discord
      dotnet-runtime
      dunst
      fortune
      libreoffice-fresh
      mattermost-desktop
      mpvScripts.mpris
      neo-cowsay
      neofetch
      nerdfonts
      playerctl
      powerline-fonts
      rsync
      skypeforlinux
      sops
      steam-run
      telegram-desktop
      thefuck
      tinyfugue
      virt-manager
      yubioath-flutter
      (python3.withPackages(ps: with ps; [
        jinja2
        jupyter
        lxml
        pandas
      ]))
    ];
    stateVersion = "23.05";
  };

  pam.yubico.authorizedYubiKeys.ids = [
    "vvelbjguhtlv"
    "ccccccjfkvnh"
    "ccccccvvktff"
  ];

  programs = {
    firefox.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    i3status.enable = true;
    nix-index.enable = true;
    rofi.enable = true;
    vscode.enable = true;
  };

  services.nextcloud-client.enable = true;

  xdg.desktopEntries = {
    sonic3air = {
      name = "Sonic 3: Angel Island Revisited";
      genericName = "Sonic Fan Remaster of Sonic 3 & Knuckles";
      type = "Application";
      exec = "steam-run /mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux";
      terminal = false;
      categories = [ "Game" ];
      icon = "/mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux/data/icon.png";
    };
    am2r = {
      name = "Another Metroid 2 Remake";
      genericName = "Metroid Fan Remake of Metroid 2: Return of Samus";
      type = "Application";
      exec = "steam-run  /mnt/games/Another\\ Metroid\\ 2\\ Remake/runner";
      terminal = false;
      categories = [ "Game" ];
      icon = "/mnt/games/Another\\ Metroid\\ 2\\ Remake/icon.png";
    };
  };

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        defaultWorkspace = "workspace number 0";
        terminal = "kitty";
        modifier = "Mod4";
        menu = "${pkgs.rofi}/bin/rofi -show drun";
        fonts = {
          names = ["FiraCode Nerd Font"];
        };
        keybindings = let
          modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Shift+w" = "sticky toggle";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };
        startup = [
          { command = "i3-msg 'workspace 1; append_layout /home/yaro/.config/i3/layout.json'"; notification = false; }
          { command = "firefox"; notification = false; }
          { command = "thunderbird"; notification = false; }
          { command = "hexchat"; notification = false; }
          { command = "discord"; notification = false; }
          { command = "kitty"; notification = false; }
          { command = "skypeforlinux"; notification = false; }
          { command = "telegram-desktop"; notification = false; }
          { command = "dunst"; notification = false; }
        ];
      };
      extraConfig = "for_window [title=\"Picture-in-Picture\"] sticky enable";
    };
  };
}
