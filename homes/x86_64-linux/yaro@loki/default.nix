{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  imports = [
    ../../../common/home.nix
  ];

  nixpkgs.config.allowUnfree = true;

  united = {
    autorandr.enable = true;
    git.enable = true;
    gnupg.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    net-utils.enable = true;
    thunderbird.enable = true;
    tmux.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };

  home = {
    homeDirectory = "/home/yaro";
    file = {
      layout = {
        source = ../../../files/i3/layout.json;
        target = ".config/i3/layout.json";
      };
    };
    packages = with pkgs;
    let
      wp-gen = inputs.wallpaper-generator.packages.${system}.wp-gen;
    in [
      bitwarden
      dex
      diffuse
      discord
      dotnet-runtime
      dunst
      libreoffice-fresh
      mattermost-desktop
      mpvScripts.mpris
      neofetch
      nerdfonts
      networkmanagerapplet
      nitrogen
      playerctl
      powerline-fonts
      rsync
      scrot
      skypeforlinux
      sops
      steam-run
      telegram-desktop
      tinyfugue
      virt-manager
      wp-gen
      yubioath-flutter
    ];
    stateVersion = "23.05";
  };

  programs = {
    firefox.enable = true;
    i3status.enable = true;
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
          { command = "wallpaper-generator `ls ${inputs.wallpaper-generator.packages.x86_64-linux.wp-gen}/bin/generators | grep .lua | shuf -n 1 | cut -d . -f 1` -o /tmp/background.png --width 2560 --height 1440 && nitrogen --restore"; notification = false; }
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
