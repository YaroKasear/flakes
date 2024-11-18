{ config, lib, ... }:
with lib;

let
  cfg = config.united.tailscale;

in
{
  options.united.headscale = {
    enable = mkEnableOption "Tailscale";
    exitNode = mkEnableOption "Whether or not this node should be used as an exit point.";
  };

  config = mkIf cfg.enable {
    age.secrets."tsAuthFile" = { };
    services.tailscale = {
      enable = true;
      extraUpFlags = [
        "--accept-routes"
        (mkIf exitNode "--advertise-exit-node")
        (mkIf exitNode "--advertise-routes=10.0.10.1/32,10.10.10.2/32,10.40.10.1/32")
        "--login-server=https://vpn.kasear.net"
        (mkIf exitNode != true "--shields-up")

      ];
      useRoutingFeatures =
        if cfg.exitNode then
          "server"
        else
          "client";
    };
  };
}
