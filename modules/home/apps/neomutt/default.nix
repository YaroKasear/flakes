{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.neomutt;
in {
  options.united.neomutt = {
    enable = mkEnableOption "Neomutt client!";
  };

  config = mkIf cfg.enable {
    programs.neomutt = {
      enable = true;
      checkStatsInterval = 60;
    };

    accounts.email.accounts = {
      Personal = {
        neomutt = {
          enable = true;
          mailboxType = "imap";
        };
        smtp.tls.enable = true;
        passwordCommand = "cat /run/user/1000/secrets/personal";
      };
      Heartbeat = {
        neomutt = {
          enable = true;
          mailboxType = "imap";
        };
        smtp.tls.enable = true;
        passwordCommand = "cat /run/user/1000/secrets/heartbeat";
      };
      Wanachi = {
        neomutt = {
          enable = true;
          mailboxType = "imap";
        };
        smtp.tls.enable = true;
        passwordCommand = "cat /run/user/1000/secrets/wanachi";
      };
      Work = {
        neomutt = {
          enable = true;
          mailboxType = "imap";
        };
        smtp.tls.enable = true;
        passwordCommand = "cat /run/user/1000/secrets/work";
      };
    };

    sops.secrets = mkIf config.united.sops.enable {
      personal.sopsFile = ./secrets.yaml;
      heartbeat.sopsFile = ./secrets.yaml;
      wanachi.sopsFile = ./secrets.yaml;
      work.sopsFile = ./secrets.yaml;
    };
  };
}