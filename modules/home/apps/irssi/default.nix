{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.irssi;
in {
  options.united.irssi = {
    enable = mkEnableOption "IRSSI IRC Client";
  };

  config = mkIf cfg.enable {
    programs = {
      irssi = {
        enable = true;
        networks = {
          Twitch = {
            nick = "YaroKasear";
            server = {
              autoConnect = true;
              ssl.enable = true;
              address = "irc.twitch.tv";
              port = 6697;
            };
            channels = {
              YaroKasear.autoJoin = true;
            };
          };
        };
      };
    };

    sops.secrets.twitchPassword = mkIf config.united.sops.enable {
      sopsFile = ./secrets.yaml;
    };
  };
}