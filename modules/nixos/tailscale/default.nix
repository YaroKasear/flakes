{ config, lib, inputs, ... }:
with lib;
with lib.united;

let
  cfg = config.united.tailscale;
  secrets-directory = inputs.self + "/secrets/modules/tailscale/";

in
{
  options.united.tailscale = {
    enable = mkEnableOption "Tailscale";
    router = mkEnableOption "Whether or not this node should be used as an exit point.";
    accept-dns = mkOpt types.bool false "Whether to accept DNS from the tailnet.";
    accept-routes = mkOpt types.bool false "Whether to accept routes from a Tailscale router.";
    accept-connections = mkOpt types.bool false "Should the node accept connections through the tailnet?";
    local-network = mkEnableOption "Is the node on the same network as the control plane?";
  };

  config = mkIf cfg.enable {
    age.secrets."tsAuthFile-${config.networking.hostName}".rekeyFile = secrets-directory + "tsAuthFile-${config.networking.hostName}.age";

    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets."tsAuthFile-${config.networking.hostName}".path;
      extraUpFlags = [
        "--accept-dns${if cfg.accept-dns then "" else "=false"}"
        "--accept-routes${if cfg.accept-routes then "" else "=false"}"
        # (mkIf cfg.router "--advertise-routes=10.0.10.1/32,10.10.10.1/32,10.40.10.1/32")
        "--advertise-routes=${if cfg.router then "10.0.10.1/32,10.10.10.1/32,10.40.10.1/32" else ""}"
        "--login-server=https://vpn.kasear.net"
        # (mkIf (cfg.router != true && cfg.accept-connections != true) "--shields-up")
        "--shields-up=${if cfg.accept-connections then "false" else "true"}"
        # (mkIf (cfg.router || cfg.accept-connections == true) "--ssh")
      ];
      useRoutingFeatures =
        if cfg.router then
          "server"
        else
          "client";
    };

    # We need this so that nodes who use the tailnet for DNS can even connect to the control plane
    networking.extraHosts =
      if cfg.accept-dns && cfg.local-network then
        "10.0.10.1 vpn.kasear.net"
      else if cfg.accept-dns then
        ''
          104.21.28.95 vpn.kasear.net
          172.67.145.80 vpn.kasear.net
        ''
      else
        "";
  };
}
