{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  cfg = config.united.irssi;
in {
  options.united.irssi = {
    enable = mkEnableOption "IRSSI IRC Client";
  };

  config = mkIf cfg.enable {
    programs = {
      irssi = {
        enable = true;
      };
      zsh.shellAliases = {
        "twitchChat" = "kitty -c ${config.united.user.directories.config}/kitty/twitch.conf --class twitchChat irssi -c irc.chat.twitch.tv -p 6667 -n yarokasear -w $(cat /run/user/1000/secrets/twitchPassword)";
      };
    };

    sops.secrets.twitchPassword = mkIf config.united.sops.enable {
      sopsFile = ./secrets.yaml;
    };

    wayland.windowManager.hyprland.settings = mkIf is-linux {
      windowrulev2 = [
        "size 900 725, class:twitchChat"
        "move 100%-900 0, class:twitchChat"
        "pin, class:twitchChat"
        "noborder, class:twitchChat"
      ];
    };

    xdg.configFile."kitty/twitch.conf" = mkIf config.united.kitty.enable {
      text = ''
        background_opacity .3
      '';
    };
  };
}