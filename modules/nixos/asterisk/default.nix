{ lib, config, inputs, pkgs, ... }:

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
        "voicemail.conf" = {
          rekeyFile = secrets-directory + "voicemail.conf.age";
          path = "/etc/asterisk/voicemail.conf";
          owner = "asterisk";
          group = "asterisk";
          mode = "400";
          symlink = false;
        };
      };
    };

    environment.etc."asterisk/update-pjsip-ip.sh" = {
      text = ''
        #!${pkgs.bash}/bin/sh

        CURRENT_IP=$(curl -s https://api.ipify.org)
        STORED_IP=$(cat /var/lib/ip-change/current_ip)
        CONF_FILE="/etc/asterisk/pjsip_dynamic_ip.conf"

        if [ "$CURRENT_IP" != "$STORED_IP" ]; then
            echo $CURRENT_IP > /var/lib/ip-change/current_ip
            echo "; Auto-generated file" > $CONF_FILE
            echo "external_media_address=$${CURRENT_IP}" >> $CONF_FILE
            echo "external_signaling_address=$${CURRENT_IP}" >> $CONF_FILE
            asterisk -rx "pjsip reload"
        fi
      '';
      group = "asterisk";
      user = "asterisk";
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
          ; external_media_address=140.228.165.7
          ; external_signaling_address=140.228.165.7
          #include pjsip_dynamic_ip.conf

          #include callcentric.conf
        '';
        "extensions.conf" = ''
          #include callcentric-did.conf
        '';
        "logger.conf" = ''
          [general]

          [logfiles]
          syslog.local0 => notice,warning,error,verbose(3)
          console => warning,error,verbose,verbose(3)
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