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
        passwordCommand = "echo 'Not now, thanks.'";
      };
      Heartbeat = {
        neomutt = {
          enable = true;
          mailboxType = "imap";
        };
        smtp.tls.enable = true;
        passwordCommand = "echo 'Not now, thanks.'";
      };
      Wanachi = {
        neomutt = {
          enable = true;
          mailboxType = "imap";
        };
        smtp.tls.enable = true;
        passwordCommand = "echo 'Not now, thanks.'";
      };
      Work = {
        neomutt = {
          enable = true;
          mailboxType = "imap";
        };
        smtp.tls.enable = true;
        passwordCommand = "echo 'Not now, thanks.'";
      };
    };
  };
}