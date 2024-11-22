{ lib, config, ... }:

with lib;
with lib.united;
let
  mkLocalData = a: attrsets.mapAttrsToList (name: value: "\"${name}. IN A ${value}\"") a;

  external = "10.0.0.1";
  public = "10.0.10.1";
  internal = "10.10.0.1";
  coreSwitch = "10.10.0.2";
  desktopSwitch = "10.10.0.3";
  wirelessAccessPoint = "10.10.0.4";
  private = "10.10.10.1";
  printer = "10.10.20.1";
  tuner = "10.10.20.2";
  camera1 = "10.30.30.1";
  camera2 = "10.30.30.2";
  storage = "10.40.10.1";
  frontend = "10.50.0.1";

  cfg = config.united.unbound;
in
{
  options.united.unbound = {
    enable = mkEnableOption "Unbound";
    hosts = mkOpt (types.attrsOf types.str)
      {
        "io.dmz.kasear.net" = external;
        "deimos.dmz.kasear.net" = public;
        "europa.main.kasear.net" = internal;
        "terra.main.kasear.net" = coreSwitch;
        "artemis.main.kasear.net" = desktopSwitch;
        "luna.main.kasear.net" = wirelessAccessPoint;
        "phobos.main.kasear.net" = private;
        "printer.main.kasear.net" = printer;
        "tv.main.kasear.net" = tuner;
        "ganymede.storage.kasear.net" = storage;
        "camera1.iot.kasear.net" = camera1;
        "camera2.iot.kasear.net" = camera2;
        "eris.jupiter.kasear.net" = frontend;
        "public.kasear.net" = public;
        "private.kasear.net" = private;
        "storage.kasear.net" = storage;
        "kasear.net" = public;
        "www.kasear.net" = public;
        "www.bethybee.net" = public;
        "cloud.kasear.net" = public;
        "core.kasear.net" = coreSwitch;
        "external.kasear.net" = external;
        "frontend.kasear.net" = frontend;
        "internal.kasear.net" = internal;
        "majike.kasear.net" = public;
        "media.kasear.net" = public;
        "pbx.kasear.net" = private;
        "test.kasear.net" = public;
        "vault.kasear.net" = public;
        "vikali.kasear.net" = public;
        "vpn.kasear.net" = public;
        "yaro.kasear.net" = public;
      } "List of local-zone hostnames and their IP addresses.";
  };

  config = mkIf cfg.enable {
    services = {
      unbound = {
        enable = true;
        blocklist = enabled;
        resolveLocalQueries = (!config.united.tailscale.enable) || (!config.united.tailscale.accept-dns);
        settings = {
          server = {
            access-control = [
              "10.0.0.0/8 allow"
              "127.0.0.1/8 allow"
              "100.64.0.0/10 allow"
            ];
            interface = "0.0.0.0";
            tls-upstream = (!config.united.tailscale.enable) || (!config.united.tailscale.accept-dns);
            local-zone = [ "\"kasear.net\" transparent" ];
            local-data = (mkLocalData cfg.hosts);
            logfile = "log/unbound.log";
            log-time-ascii = "yes";
            log-queries = "yes";
            log-replies = "yes";
          };
          forward-zone = {
            name = "\".\"";
            forward-addr =
              if config.united.tailscale.enable && config.united.tailscale.accept-dns then [
                "100.100.100.100"
              ] else [
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
