{ config, lib, inputs, ... }:
with lib;

let
  cfg = config.united.tailscale;
  secrets-directory = inputs.self + "/secrets/modules/tailscale/";

in
{
  options.united.tailscale = {
    enable = mkEnableOption "Tailscale";
    exitNode = mkEnableOption "Whether or not this node should be used as an exit point.";
  };

  config = mkIf cfg.enable {
    age.secrets."tsAuthFile-${config.networking.hostName}".rekeyFile = secrets-directory + "tsAuthFile-${config.networking.hostName}.age";
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets."tsAuthFile-${config.networking.hostName}".path;
      extraUpFlags = [
        "--accept-routes"
        (mkIf cfg.exitNode "--advertise-exit-node")
        (mkIf cfg.exitNode "--advertise-routes=10.0.10.1/32,10.10.10.2/32,10.40.10.1/32")
        "--login-server=https://vpn.kasear.net"
        (mkIf (cfg.exitNode != true) "--shields-up")
        "--exit-node-allow-lan-access"
      ];
      useRoutingFeatures =
        if cfg.exitNode then
          "server"
        else
          "client";
    };
  };
}
