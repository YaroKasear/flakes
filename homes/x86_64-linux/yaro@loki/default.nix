{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:
with lib.united;

{
  united = {
    admin = enabled;#  = enabled;
    am2r = enabled;
    asciiquarium = {
      enable = true;
      # smart-wallpaper = config.united.wayland.enable;
      smart-wallpaper = false;
    };
    common = enabled;
    desktop = {
      enable = true;
      linux.waylandSupport = true;
    };
    discord = enabled;
    hyprland.floating = false;
    lutris = disabled;
    mpv = enabled;
    obs-studio = disabled;
    obsidian = enabled;
    persistent = enabled;
    protonmail-bridge = enabled;
    rust = enabled;
    sonic3air = enabled;
    tinyfugue = enabled;
    wayland.compositor = "plasma"; # TODO: Some day nVidia will be good wnough for Sway.`
    wine = enabled;
    user = {
      directories = {
        documents = "${config.united.user.directories.home}/Nextcloud/Documents";
        games = "/mnt/games";
        music = "/mnt/music";
        pictures = "/mnt/pictures";
        screenshots = "${config.united.user.directories.home}/Pictures/Screenshots";
        wallpapers = "${config.united.user.directories.home}/Pictures/Wallpapers";
        videos = "/mnt/videos";
      };
      icon = ./files/techkat.png;
    };
    style = with config.united.style; {
      enable = true;
      catppuccin.frappe = disabled;
      catppuccin.latte = disabled;
      catppuccin.macchiato = disabled;
      catppuccin.mocha = enabled;
      effects.shadow = {
        active-color = config.united.style.colors.active_border_color;
        inactive-color = config.united.style.colors.inactive_border_color;
        offsetX = 0;
        offsetY = 0;
        spread = 20;
      };
    };
  };

  programs.plasma.panels = [
    {
      location = "top";
      height = 32;
      widgets = [
        {
          name = "org.kde.plasma.kickoff";
          config.General = {
            compactMode = "true";
            icon = "nix-snowflake-white";
          };
        }
        {
          name = "org.kde.plasma.folder";
          config.General.url = "file://${config.united.user.directories.home}";
        }
        {
          name = "org.kde.plasma.pager";
          config.General.currentDesktopSelected = "ShowDesktop";
        }
        {
          name = "org.kde.plasma.userswitcher";
          config.General = {
            showFace = "true";
            showTechnicalInfo = "true";
          };
        }
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.panelspacer"
        "org.kde.plasma.marginsseparator"
        {
          systemTray.items = {
            shown = [
              "org.kde.plasma.volume"
            ];
            hidden = [
              "org.kde.plasma.bluetooth"
              "org.kde.plasma.networkmanagement"
            ];
          };
        }
        {
          digitalClock = {
            calendar.firstDayOfWeek = "sunday";
            time.format = "12h";
          };
        }
      ];
    }
    {
      location = "bottom";
      height = 64;
      lengthMode = "fit";
      hiding = "dodgewindows";
      floating = true;
      widgets = [
        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            launchers = [
              "applications:systemsettings.desktop"
              "applications:org.kde.dolphin.desktop"
              "applications:kitty.desktop"
              "applications:firefox.desktop"
              "applications:thunderbird.desktop"
              "applications:discord.desktop"
              "applications:skypeforlinux.desktop"
              "applications:org.telegram.desktop.desktop"
              "applications:steam.desktop"
              "applications:code.desktop"
            ];
            groupingStrategy = "3";
            separateLaunchers = "false";
            showOnlyCurrentDesktop = "false";
          };
        }
      ];
    }
  ];

  home = {
    packages = with pkgs; [
      audacity
      dotnet-runtime
      gimp
      handbrake
      makemkv
      mosquitto
      skypeforlinux
      telegram-desktop
      united.python-fabric
      # united.sonic3air
    ];
    persistence."/persistent${config.united.user.directories.home}" =
    let
      mkHomeCanon = dir: lib.replaceStrings ["${config.united.user.directories.home}/"] [""] dir;

      cache-directory = mkHomeCanon config.united.user.directories.cache;
      config-directory = mkHomeCanon config.united.user.directories.config;
      data-directory = mkHomeCanon config.united.user.directories.data;
      state-directory = mkHomeCanon config.united.user.directories.state;
    in {
      allowOther = true;
      directories = [
        "${config-directory}/heroic"
        "${config-directory}/protonmail"
        "${config-directory}/skypeforlinux"
        "${config-directory}/StardewValley/Saves"
        "${config-directory}/discord"
        "${data-directory}/protonmail"
        "${data-directory}/TelegramDesktop"
        {
          directory = "${data-directory}/Steam";
          method = "symlink";
        }
        "flakes"
      ];
    };
  };

  xdg = {
    mimeApps = {
      defaultApplications = {
        "x-scheme-handler/tg" = [ "userapp-Telegram Desktop-8GRXI2.desktop" ];
      };
      associations.added."x-scheme-handler/tg" = [ "org.telegram.desktop.desktop;userapp-Telegram Desktop-ZSJDH2.desktop;userapp-Telegram Desktop-8GRXI2.desktop;" ];
    };
  };

  accounts = {
    email.accounts = {
      Personal = {
        address = "yarokasear@gmail.com";
        flavor = "gmail.com";
        primary = true;
        realName = "Yaro Kasear";
        thunderbird = {
          enable = true;
          settings = id: {
            "mail.smtpserver.smtp_${id}.authMethod" = 10;
            "mail.server.server_${id}.authMethod" = 10;
          };
        };
        gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = true;
        };
      };
      Heartbeat = {
        address = "yaro@kasear.net";
        flavor = "plain";
        realName = "Yaro Kasear";
        userName = "yaro@kasear.net";
        thunderbird = enabled;
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
      };
      Wanachi = {
        address = "wanachi@tlkmuck.org";
        flavor = "gmail.com";
        realName = "Wanachi";
        thunderbird = {
          enable = true;
          settings = id: {
            "mail.smtpserver.smtp_${id}.authMethod" = 10;
            "mail.server.server_${id}.authMethod" = 10;
          };
        };
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = true;
        };
      };
    };
    calendar.accounts = {
      Personal = {
        primary = true;
        remote = {
          type = "google_calendar";
          userName = "yarokasear@gmail.com";
        };
      };
    };
  };
}
