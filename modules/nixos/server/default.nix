{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

  cfg = config.united.server;
in {
  options.united.server = {
    enable = mkEnableOption "server";
  };

  config = mkIf cfg.enable {
    age.secrets.wireguard-key =
    {
      rekeyFile = secrets-directory + "wireguard-key";
      path = "/var/wg-key";
      owner = "systemd-network";
      mode = "400";
      symlink = false;
    };

    systemd.network = {
      enable = true;
      netdevs = {
        "10-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
            MTUBytes = "1500";
          };
          wireguardConfig = {
            PrivateKeyFile = config.age.secrets.wireguard-key.path;
          };
          wireguardPeers = [
            {
              wireguardPeerConfig = {
                AllowedIPs = [
                  "0.0.0.0/0"
                ];
                Endpoint = "45.79.35.167:2001";
                PublicKey = "ycvzU34e3KpPadkwkNYFpq2R1n2IkqWbs8ZDBo8NA3c=";
              };
            }
          ];
        };
      };
      networks.wg0 = {
        matchConfig.Name = "wg0";
        address = ["10.60.10.1/32"];
        DHCP = "no";
        dns = ["10.10.10.1"];
        ntp = ["10.10.10.1"];
        gateway = ["10.60.0.1"];
        networkConfig = {
          IPv6AcceptRA = false;
        };
      };
    };

    united.common = enabled;
  };
}