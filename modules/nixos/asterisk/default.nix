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
          mode = "440";
          symlink = false;
        };
        "callcentric-did.conf" = {
          rekeyFile = secrets-directory + "callcentric-did.conf.age";
          path = "/etc/asterisk/callcentric-did.conf";
          owner = "asterisk";
          group = "asterisk";
          mode = "440";
          symlink = false;
        };
        "voicemail.conf" = {
          rekeyFile = secrets-directory + "voicemail.conf.age";
          path = "/etc/asterisk/voicemail.conf";
          owner = "asterisk";
          group = "asterisk";
          mode = "440";
          symlink = false;
        };
      };
    };

    environment.etc."asterisk/update-pjsip-ip.sh" = {
      text = ''
        #!${pkgs.bash}/bin/sh

        CURRENT_IP=$(${pkgs.dnsutils}/bin/dig +short myip.opendns.com @resolver1.opendns.com)
        STORED_IP=$(cat /var/lib/ip-change/current_ip)
        CONF_FILE="/etc/asterisk/pjsip_dynamic_ip.conf"

        if [ "$CURRENT_IP" != "$STORED_IP" ]; then
            echo $CURRENT_IP > /var/lib/ip-change/current_ip
            echo "; Auto-generated file" > $CONF_FILE
            echo "external_media_address=''${CURRENT_IP}" >> $CONF_FILE
            echo "external_signaling_address=''${CURRENT_IP}" >> $CONF_FILE
            asterisk -rx "pjsip reload"
        fi
      '';
      group = "asterisk";
      user = "asterisk";
      mode = "540";
    };

    fileSystems = {
      "/var/spool/asterisk" = {
        device = "storage.kasear.net:/mnt/data/server/phobos/asterisk/spool";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
      };
      "/var/log/asterisk" = {
        device = "storage.kasear.net:/mnt/data/server/phobos/asterisk/log";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
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

    system.activationScripts.createIPStorageFile = ''
      mkdir -p /var/lib/ip-change
      touch /var/lib/ip-change/current_ip
      chown -R asterisk:asterisk /var/lib/ip-change
    '';

    systemd = {
      services.ip-change-detect = {
        description = "Detect IP change and update Asterisk PJSIP configuration";
        path = [
          pkgs.curl
          config.services.asterisk.package
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "/etc/asterisk/update-pjsip-ip.sh";
          Restart = "on-failure";
        };
        wantedBy = [ "multi-user.target" ];
        before = [ "asterisk.service" ];
      };
      timers.ip-change-detect = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "5min";
        };
      };
    };

    networking = {
      firewall = {
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
      users = {
        asterisk = {
          isSystemUser = true;
          uid = 192;
          group = "asterisk";
        };
        yaro.extraGroups = ["asterisk"];
      };
      groups.asterisk.gid = 192;
    };
  };
}