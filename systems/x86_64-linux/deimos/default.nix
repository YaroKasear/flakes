{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

# PUBLIC SERVER

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    identityPaths = ["/persistent/etc/ssh/ssh_host_ed25519_key"];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBR7FHCr/xnQhQ0eeU14MoH78bF1XQwhA34juRFC9S3A";
    };
    secrets = {
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
      wireguard-key =
      {
        rekeyFile = secrets-directory + "wireguard-key";
        path = "/var/wg-key";
        owner = "systemd-network";
        mode = "400";
        symlink = false;
      };
    };
  };

  networking = {
    hostId = "59d99151";
    hostName = "deimos";
    firewall = {
      checkReversePath = "loose";
      logRefusedConnections = true;
      logRefusedPackets = true;
      logReversePathDrops = true;
    };
    wg-quick.interfaces = {
      wg0 = {
        address = ["10.60.10.1/32"];
        dns = ["10.10.0.1" "10.0.0.1"];
        privateKeyFile = config.age.secrets.wireguard-key.path;

        peers = [
          {
            publicKey = "ycvzU34e3KpPadkwkNYFpq2R1n2IkqWbs8ZDBo8NA3c=";
            allowedIPs = ["0.0.0.0/0" "::/0"];
            endpoint = "45.79.35.167:2001";
            persistentKeepalive = 25;
          }
        ];
      };
    };
    nat = {
      enable = true;
      internalInterfaces = [
        "ve-+"
      ];
      # externalInterface = config.systemd.network.networks."20-dmz".matchConfig.Name;
      externalInterface = "wg0";
      externalIP = "10.60.10.1"; # Despite what the documentation says, it does NOT assign the interface's IP...
      extraCommands = ''
        iptables -t nat -A POSTROUTING -d 10.10.0.0/16 -j SNAT --to-source 10.0.10.1
        iptables -t nat -A POSTROUTING -d 10.20.0.0/16 -j SNAT --to-source 10.0.10.1
      '';
    };
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "10-storage" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan40";
        };
        vlanConfig.Id = 40;
      };
    };
    networks = {
      "20-dmz" = {
        matchConfig.Name = "eno2";
        vlan = [
          "vlan40"
        ];
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        routes = [
          {
            Destination = "10.10.0.0/16";
            Gateway = "10.0.0.2";
            GatewayOnLink = true;
          }
          {
            Destination = "10.20.0.0/16";
            Gateway = "10.0.0.2";
            GatewayOnLink = true;
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
      "30-storage" = {
        matchConfig.Name = "vlan40";
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        dhcpV4Config = {
          UseRoutes = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  united = {
    apache-vikali = enabled;
    apache-majike = enabled;
    deimos-mounts = enabled;
    emby = disabled;
    jellyfin = enabled;
    nextcloud = enabled;
    nginx-default = enabled;
    nginx-proxy = enabled;
    nginx-yaro = enabled;
    server = enabled;
    vaultwarden = enabled;
    common.banner = ''
      [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░[0m
      [90;40m░[94m█▀▄[90m░[94m█▀▀[90m░[94m▀█▀[90m░[94m█▄█[90m░[94m█▀█[90m░[94m█▀▀[90m░[0m
      [90;40m░[94m█[90m░[94m█[90m░[94m█▀▀[90m░░[94m█[90m░░[94m█[90m░[94m█[90m░[94m█[90m░[94m█[90m░[94m▀▀█[90m░[0m
      [90;40m░[94m▀▀[90m░░[94m▀▀▀[90m░[94m▀▀▀[90m░[94m▀[90m░[94m▀[90m░[94m▀▀▀[90m░[94m▀▀▀[90m░[0m
      [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░[0m
    '';
  };

  # START SHORT-TERM CONTAINERS/DOMAINS

  containers = {
    prime = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = "192.168.1.18";

      config = { pkgs, ... }:
      {
        services.nginx = {
          enable = true;
          recommendedOptimisation = true;
          virtualHosts."prime.kasear.net".locations."/".root = "/etc/prime";
        };

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 ];
          };
        };

        environment.etc = {
          "prime/index.html".text = ''
            <!doctype html>
            <html lang="en">

            <head>
              <meta charset="utf-8">
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <title>Is it Prime?</title>
              <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
              <style>
                body,
                html {
                  height: 100vh;
                  transition: background-color .5s;
                }

                .btn {
                  transition: all .5s;
                }
              </style>
            </head>

            <body>
              <div class="container d-flex flex-column justify-content-center h-100">
                <div class="border shadow-sm p-3 rounded bg-light">
                  <div class="input-group input-group-sm">
                    <span class="input-group-text user-select-none">Input Number</span>
                    <input type="number" class="form-control shadow-none" id="numberBox" placeholder="Number!" oninput="numUpdate()" autocomplete="off">
                    <button class="btn btn-primary disabled" id="primeButton" onclick="checkPrime()">Is it prime?</button>
                  </div>
                </div>
              </div>
              <script src="bootstrap/js/bootstrap.min.js"></script>
              <script>
                const $ = document.querySelector.bind(document);

                function numUpdate() {
                  let numberBox = $('#numberBox');
                  let primeButton = $('#primeButton');

                  if (!numberBox.value) {
                    primeButton.classList.add('disabled');
                  } else {
                    primeButton.classList.remove('disabled');
                  }

                  if (numberBox.value < 0) numberBox.value = 0;
                }

                function checkPrime() {
                  let body = $('body');
                  let numberBox = $('#numberBox');
                  let bPrime = isPrime(numberBox.value);

                  body.classList.remove(bPrime ? "bg-danger" : "bg-success");
                  body.classList.add(bPrime ? "bg-success" : "bg-danger");
                }

                function isPrime(n) {
                  if (n < 2) return false;
                  if (n == 2) return true;

                  for (let i = 2; i <= Math.sqrt(n); ++i)
                    if (n % i == 0) return false;

                  return true;
                }
              </script>
            </body>

            </html>
          '';
          "prime/bootstrap".source = "${pkgs.twitterBootstrap}";
      };

        system.stateVersion = "24.05";
      };
    };
    nginx-proxy.config.services.nginx.virtualHosts."prime.kasear.net" = network.create-proxy {
      host = "192.168.1.18";
      port = 80;
      extra-config = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/default/cert.pem";
        sslCertificateKey = "/var/lib/acme/default/key.pem";
      };
    };
  };

  # END CONTAINERS/DOMAINS
}