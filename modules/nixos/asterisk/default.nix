{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.asterisk;
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

in {
  options.united.asterisk = {
    enable = mkEnableOption "asterisk";
  };

  config = mkIf cfg.enable {
    age = {
      secrets = {
        "callcentric.conf" = {
          rekeyFile = secrets-directory + "callcentric.conf.age";
          path = "/run/callcentric.conf";
          owner = "asterisk";
          group = "asterisk";
          mode = "400";
          symlink = false;
        };
        "callcentric-did.conf" = {
          rekeyFile = secrets-directory + "callcentric-did.conf.age";
          path = "/run/callcentric-did.conf";
          owner = "asterisk";
          group = "asterisk";
          mode = "400";
          symlink = false;
        };
      };
    };

    containers.asterisk = {
      autoStart = false;
      config = ../../../containers/asterisk/default.nix;
      ephemeral = true;
      bindMounts = {
        "/etc/asterisk/callcentric.conf" = {
          hostPath = config.age.secrets."callcentric.conf".path;
          isReadOnly = true;
        };
        "/etc/asterisk/callcentric-did.conf" = {
          hostPath = config.age.secrets."callcentric-did.conf".path;
          isReadOnly = true;
        };
      };
    };

    networking = {
      nftables = enabled;
      firewall = {
        enable = true;
        allowedUDPPorts = [ 5060 ];
        allowedUDPPortRanges = [{
          from = 10000;
          to = 20000;
        }];
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