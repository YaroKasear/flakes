{ lib, config, ... }:

with lib;
with lib.united;
let
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
          };
          forward-zone = {
            name = "\".\"";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"
            ];
          };
        };
      };
      resolved = disabled;
      dnsmasq = disabled;
    };
  };
}
