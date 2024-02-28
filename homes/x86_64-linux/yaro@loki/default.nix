{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    am2r.enable = true;
    common.enable = true;
    desktop.enable = true;
    sonic3air.enable = true;
    wayland.enable = true;
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
}