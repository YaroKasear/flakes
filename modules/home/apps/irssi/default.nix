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
        # networks= {
        #   Twitch = {
        #     nick = "yarokasear";
        #     channels = {
        #       yarokasear.autoJoin = true;
        #     };
        #     server = {
        #       address = "irc.chat.twitch.tv";
        #       port = 6697;
        #       ssl.enable = true;
        #     };
        #     autoCommands = [
        #       "/quote CAP REQ :twitch.tv/membership"
        #     ];
        #   };
        # };
        # The above doesn't work since apparently IRSSI *must* have the password or else it'll send God-knows-what to Twitch.
      };
      zsh.shellAliases = {
        "twitchChat" = "kitty -c $XDG_CONFIG_HOME/kitty/twitch.conf --class twitchChat irssi -c irc.chat.twitch.tv -p 6667 -n yarokasear -w $(cat /run/user/1000/secrets/twitchPassword)";
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
        "noblur, class:twitchChat"
      ];
    };

    xdg.configFile."kitty/twitch.conf" = mkIf config.united.kitty.enable {
      text = ''
        background_opacity .3
      '';
    };
  };
}