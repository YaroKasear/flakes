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
<<<<<<< Updated upstream
    router = mkEnableOption "Whether or not this node should be used as an exit point.";
    accept-routes = mkOpt types.bool false "Whether to accept routes from a Tailscale router.";
=======
    router = mkEnableOption "Whether or not this node should be used as a subnet router.";
>>>>>>> Stashed changes
  };

  config = mkIf cfg.enable {
    age.secrets."tsAuthFile-${config.networking.hostName}".rekeyFile = secrets-directory + "tsAuthFile-${config.networking.hostName}.age";
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets."tsAuthFile-${config.networking.hostName}".path;
      extraUpFlags = [
<<<<<<< Updated upstream
        "--accept-routes${if cfg.accept-routes then "" else "=false"}"
=======
        "--accept-routes"
>>>>>>> Stashed changes
        (mkIf cfg.router "--advertise-routes=10.0.10.1/32,10.10.10.2/32,10.40.10.1/32")
        "--login-server=https://vpn.kasear.net"
        (mkIf (cfg.router != true) "--shields-up")
      ];
      useRoutingFeatures =
        if cfg.router then
          "server"
        else
          "client";
    };

    environment.persistence."/persistent".directories = [ "/var/lib/tailscale" ];
  };
}
