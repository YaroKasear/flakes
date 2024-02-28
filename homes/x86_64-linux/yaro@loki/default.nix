{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    am2r.enable = true;
    asciiquarium = {
      enable = true;
      smart-wallpaper = config.united.wayland.enable;
    };
    common.enable = true;
    desktop.enable = true;
    discord.enable = true;
    git.enable = true;
    gnupg.enable = true;
    irssi.enable = true;
    lutris.enable = true;
    mpv.enable = true;
    net-utils.enable = true;
    obs-studio.enable = true;
    protonmail-bridge.enable = true;
    sops.enable = true;
    sonic3air.enable = true;
    tinyfugue.enable = true;
    wayland.enable = true;
    wine.enable = true;
    yubikey.enable = true;
    user = {
      directories = {
        documents = "${config.united.user.directories.home}/Personal Cloud/Documents";
        games = "/mnt/games";
        music = "/mnt/music";
        pictures = "/mnt/pictures";
        screenshots = "${config.united.user.directories.home}/Pictures/Screenshots";
        wallpapers = "${config.united.user.directories.home}/Pictures/Wallpapers";
        videos = "/mnt/videos";
      };
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
      age
      audacity
      dotnet-runtime
      gimp
      mosquitto
      nvd
      snowfallorg.flake
      skypeforlinux
      sops
      telegram-desktop
      traceroute
      virt-manager
    ];
    file."${config.united.user.directories.pictures}/techkat.png".source = ./files/techkat.png;
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
}