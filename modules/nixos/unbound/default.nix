{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  common-secrets = inputs.self + "/secrets/common/";

  mkLocalData = a: attrsets.mapAttrsToList (name: value: "\"${name}. IN A ${value}\"") a;

  external = "10.0.0.1";
  public = "10.0.10.1";
  internal = "10.10.0.1";
  coreSwitch = "10.10.0.2";
  desktopSwitch = "10.10.0.3";
  wirelessAccessPoint = "10.10.0.4";
  private = "10.10.10.2";
  printer = "10.10.20.1";
  tuner = "10.10.20.2";
  camera1 = "10.30.30.1";
  camera2 = "10.30.30.2";
  storage = "10.40.10.1";
  frontend = "10.50.0.1";

  cfg = config.united.unbound;
in {
  options.united.unbound = {
    enable = mkEnableOption "Unbound";
    hosts = mkOpt (types.attrsOf types.str) {
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
        "yaro.kasear.net" = public;
      } "List of local-zone hostnames and their IP addresses.";
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
              # "${config.age.secrets."local-zone.conf".path}"
              "${inputs.blocklist.packages.x86_64-linux.default}/blocklist.conf"
            ];
            local-zone = ["\"kasear.net\" transparent"];
            local-data = (mkLocalData cfg.hosts);
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
          mode = "644";
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
