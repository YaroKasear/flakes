{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    admin.enable = true;
    am2r.enable = true;
    asciiquarium = {
      enable = true;
      smart-wallpaper = config.united.wayland.enable;
    };
    common.enable = true;
    desktop = {
      enable = true;
      linux.waylandSupport = true;
    };
    discord.enable = true;
    irssi.enable = true;
    lutris.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    protonmail-bridge.enable = true;
    sonic3air.enable = true;
    tinyfugue.enable = true;
    wayland.compositor = "hyprland";
    wine.enable = true;
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
      catppuccin.frappe.enable = true;
      effects.shadow = {
        active-color = config.united.style.colors.active_border_color;
        inactive-color = config.united.style.colors.inactive_border_color;
        offsetX = 0;
        offsetY = 0;
        spread = 20;
      };
    };
  };

  programs.hyprlock.backgrounds = with config.united.style.colors; [
    {
      path = "screenshot";
      color = "rgb(${lib.replaceStrings ["#"] [""] background})";
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
    ];
    persistence."/persistent/home/yaro" = {
      allowOther = true;
      directories = [
        ".cache/cliphist"
        ".cache/oh-my-posh"
        ".config/Code"
        ".config/Nextcloud"
        ".config/protonmail"
        ".config/skypeforlinux"
        ".config/WebCord"
        ".local/share/keyrings"
        ".local/share/protonmail"
        ".local/share/TelegramDesktop"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
        ".local/share/zoxide"
        ".local/state/wireplumber"
        ".mozilla"
        ".thunderbird"
        "flakes"
      ];
      files = [
        ".zsh_history"
        ".cache/wofi-dmenu"
        ".cache/wofi-drun"
        ".cache/wofi-run"
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
        thunderbird.enable = true;
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
        thunderbird.enable = true;
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
        thunderbird.enable = true;
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
