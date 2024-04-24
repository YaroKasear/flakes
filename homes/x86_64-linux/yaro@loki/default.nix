{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
# let pkgs = inputs.nixpkgs-stable.legacyPackages."x86_64-linux"; in
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
    persistent.enable = true;
    protonmail-bridge.enable = true;
    rust.enable = true;
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
        "${config-directory}/protonmail"
        "${config-directory}/skypeforlinux"
        "${config-directory}/StardewValley/Saves"
        "${config-directory}/WebCord"
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
