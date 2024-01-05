{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-wayland = config.united.wayland.enable;

  cfg = config.united.mattermost-desktop;
in {
  options.united.mattermost-desktop = {
    enable = mkEnableOption "Mattermost-desktop";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.mattermost-desktop ];

    xdg.desktopEntries = mkIf is-wayland {
      mattermost-wl = {
        categories = [
          "Network"
          "InstantMessaging"
        ];
        comment = "Mattermost Desktop application for Linux";
        exec = "${pkgs.mattermost-desktop}/bin/mattermost-desktop --disable-gpu-sandbox";
        icon = "${pkgs.mattermost-desktop}/share/mattermost-desktop/app_icon.png";
        name = "MattermostWL";
        terminal = false;
        type = "Application";
        settings = {
          Version = "1.4";
        };
      };
    };
  };
}