{ config, lib, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
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
    ];
    file = {
      layout = {
        source = ../files/i3/layout.json;
        target = ".config/i3/layout.json";
      };
    };
  };

  programs = {
    firefox.enable = true;
    vscode.enable = true;
    rofi.enable = true;
    i3status.enable = true;
    thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        withExternalGnupg = true;
      };
    };
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
  };

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
        ];
      };
      extraConfig = "for_window [title=\"Picture-in-Picture\"] sticky enable";
    };
  };
}