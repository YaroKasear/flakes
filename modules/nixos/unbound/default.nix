{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  common-secrets = inputs.self + "/secrets/common/";

  cfg = config.united.unbound;
in {
  options.united.unbound = {
    enable = mkEnableOption "Unbound";
  };

  config = mkIf cfg.enable {
    services = {
      unbound = {
        enable = true;
        blocklist = enabled;
        settings = {
          server = {
            access-control = [
              "10.0.0.0/8 allow"
              "127.0.0.1/8 allow"
            ];
            interface = "0.0.0.0";
            tls-upstream = true;
            include = mkForce [
              "${config.age.secrets."local-zone.conf".path}"
              "${inputs.blocklist.packages.x86_64-linux.default}/blocklist.conf"
            ];
          };
          include = "${config.age.secrets."forward-zone.conf".path}";
        };
      };
      resolved = disabled;
      dnsmasq = disabled;
    };

    age = {
      secrets = {
        "forward-zone.conf" = {
          rekeyFile = common-secrets + "forward-zone.conf.age";
          owner = "unbound";
          group = "unbound";
          symlink = false;
          mode = "400";
          path = "/var/forward-zone.conf";
        };
        "local-zone.conf" = {
          rekeyFile = common-secrets + "local-zone.conf.age";
          owner = "unbound";
          group = "unbound";
          symlink = false;
          mode = "400";
          path = "/var/local-zone.conf";
        };
      };
    };
  };
}
