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
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIRAWvwciM1bRmFjdQs0JGmQMReOKOM8xnLKukiYZD2";
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
      internalInterfaces = ["ve-+"];
      externalInterface = config.systemd.network.networks."30-dmz".matchConfig.Name;
    };
  };

  systemd.network = {
    enable = true;
    netdevs = {
      # "10-wg0" = {
      #   netdevConfig = {
      #     Kind = "wireguard";
      #     Name = "wg0";
      #     MTUBytes = "1500";
      #   };
      #   wireguardConfig = {
      #     PrivateKeyFile = config.age.secrets.wireguard-key.path;
      #   };
      #   wireguardPeers = [
      #    {
      #      wireguardPeerConfig = {
      #        AllowedIPs = [
      #          "0.0.0.0/0"
      #        ];
      #        Endpoint = "45.79.35.167:2001";
      #        PersistentKeepalive = 25;
      #        PublicKey = "ycvzU34e3KpPadkwkNYFpq2R1n2IkqWbs8ZDBo8NA3c=";
      #        };
      #      }
      #   ];
      # };
      "20-storage" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan40";
        };
        vlanConfig.Id = 40;
      };
    };
    networks = {
      "30-dmz" = {
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
            routeConfig = {
              Destination = "10.10.0.0/16";
              Gateway = "10.0.0.2";
            };
          }
          {
            routeConfig = {
              Destination = "10.20.0.0/16";
              Gateway = "10.0.0.2";
            };
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
      # "40-wg0" = {
      #   matchConfig.Name = "wg0";
      #   address = ["10.60.10.1/32"];
      #   DHCP = "no";
      #   dns = [
      #     "10.10.0.1"
      #     "10.0.0.1"
      #   ];
      #   gateway = ["10.60.0.1"];
      #   networkConfig = {
      #     LinkLocalAddressing = false;
      #     IPv6AcceptRA = false;
      #   };
      #   linkConfig.RequiredForOnline = "yes";
      # };
      "50-storage" = {
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
    emby = enabled;
    nextcloud = enabled;
    nginx-default = enabled;
    nginx-proxy = enabled;
    nginx-yaro = enabled;
    server = enabled;
    vaultwarden = enabled;
  };

  # ADD ANY SHORT-TERM CONTAINERS/DOMAINS BELOW

  containers.hazelnut = let
    app = "hashazelnutpoppedyet";
    address = "192.168.100.1";
    domain = "${app}.kasear.net";

    content = pkgs.writeText "index.html" ''
      <!DOCTYPE html>
      <html>

      <head>
        <title>Has Hazelnut popped yet?!</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
      </head>

      <body class="bg-black text-danger" onload="doTheThing()">
        <div class="container-fluid d-flex display-1 align-items-center justify-content-center" style="height: 100vh;" id="text">
          STILL NOPE
        </div>
        <script src="https://code.jquery.com/jquery-3.7.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script>
          wordList1 = [
            "BELLY",
            "CAT",
            "CLAW",
            "FELINE",
            "FUR",
            "KITTEN",
            "MEOW",
            "PAW",
            "PAWS",
            "PURR",
            "TAIL"
          ];

          wordList2 = [
            "BAKING",
            "BREWING",
            "BULGING",
            "CARING",
            "CARRYING",
            "CLOAKING",
            "CLUTCHING",
            "CONSERVING",
            "COOKING",
            "CRADLING",
            "FATTENING",
            "FERMENTING",
            "FILLING",
            "FINESSING",
            "FLOURISHING",
            "FOMENTING",
            "FORMING",
            "FORTIFYING",
            "FOSTERING",
            "FROTHING",
            "KEEPING",
            "KETTLING",
            "KICKSTARTING",
            "KINDLING",
            "KNEADING",
            "MAGNIFYING",
            "MANIFESTING",
            "MARINATING",
            "MASSING",
            "MATURING",
            "MOLDING",
            "MOTIVATING",
            "NESTING",
            "OVEN",
            "PACKED",
            "PACKING",
            "PADDLING",
            "PAMPERING",
            "PENDING",
            "PERCOLATING",
            "POPPING",
            "POUCHING",
            "PRIMING",
            "PROOFING",
            "PROPAGATING",
            "PUFFED",
            "PULSING",
            "PUMPING",
            "PURRING",
            "TAMING",
            "TEAMING",
            "TEEMING",
            "TENDING",
            "TICKLING",
            "TUGGING",
            "WADING",
            "WAITING",
            "WARMING",
            "WHISPERING",
            "WOMBING"
          ];

          function doTheThing() {
            word1 = wordList1[Math.floor(Math.random() * wordList1.length)];
            word2 = wordList2[Math.floor(Math.random() * wordList2.length)];

            $('#text').text("STILL " + word1 + "-" + word2);
          }
        </script>
      </body>

      </html>
    '';

  in {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.1.1";
    localAddress = address;

    config = { ... }:
    {
      services = {
        nginx = {
          enable = true;
          virtualHosts.${domain}.locations = {
            "/" = {
              root = "/etc/hazelnut";
            };
          };
        };
      };

      environment.etc."hazelnut/index.html".source = content;

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 80 ];
        };
      };

      system.stateVersion = "24.05";
    };
  };

  containers.nginx-proxy.config.services.nginx.virtualHosts."hashazelnutpoppedyet.kasear.net" = network.create-proxy {
    host = "192.168.100.1";
    port = 80;
    extra-config = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/default/cert.pem";
      sslCertificateKey = "/var/lib/acme/default/key.pem";
    };
  };
}