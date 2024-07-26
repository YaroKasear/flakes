{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.asterisk;
  secrets-directory = inputs.self + "/secrets/modules/asterisk/";

in {
  options.united.asterisk = {
    enable = mkEnableOption "asterisk";
  };

  config = mkIf cfg.enable {
    age = {
      secrets = {
        "callcentric.conf" = {
          rekeyFile = secrets-directory + "callcentric.conf.age";
          path = "/etc/asterisk/callcentric.conf";
          owner = "asterisk";
          group = "asterisk";
          mode = "400";
          symlink = false;
        };
        "callcentric-did.conf" = {
          rekeyFile = secrets-directory + "callcentric-did.conf.age";
          path = "/etc/asterisk/callcentric-did.conf";
          owner = "asterisk";
          group = "asterisk";
          mode = "400";
          symlink = false;
        };
      };
    };

    services.asterisk = {
      enable = true;
      confFiles = {
        "pjsip.conf" = ''
          [global]
          type=global
          debug=no

          [transport-udp]
          type=transport
          protocol=udp
          bind=0.0.0.0:5060
          local_net=10.10.0.0/16
          external_media_address=140.228.165.7
          external_signaling_address=140.228.165.7

          #include callcentric.conf
        '';
        "extensions.conf" = ''
          #include callcentric-did.conf
        '';
        "logger.conf" = ''
          [general]

          [logfiles]
          syslog.local0 => notice,warning,error
          full => notice,warning,error,verbose,dtmf,fax
          console => warning,error,verbose
        '';
      };
    };

    networking = {
      firewall = {
        enable = true;
        allowedUDPPorts = [ 5060 ];
        allowedUDPPortRanges = [{
          from = 10000;
          to = 20000;
        }];
        extraCommands = ''
          iptables -A INPUT -p udp -s 10.10.20.3 -j ACCEPT
        '';
      };
    };

    users = {
      users.asterisk = {
        isSystemUser = true;
        uid = 192;
        group = "asterisk";
      };
      groups.asterisk.gid = 192;
    };
  };
}