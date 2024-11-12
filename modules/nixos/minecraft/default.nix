{ lib, config, inputs, pkgs, ... }:
with lib;
with lib.united;
let
  cfg = config.united.minecraft;
  secrets-directory = inputs.self + "/secrets/modules/minecraft/";

  commonServerProperties = {
    force-gamemode = true;
    max-players = 5;
    online-mode = false;
    player-idle-timeout = 600;
    white-list = true;
  };

  commonMods = pkgs.linkFarmFromDrvs "mods"
    (builtins.attrValues {
      LuckPerms = pkgs.fetchurl {
        url = "https://download.luckperms.net/1560/bukkit/loader/LuckPerms-Bukkit-5.4.145.jar";
        sha256 = "mfpmVvs82WisuACh0dlJTjTIDe72gUVSHx9hNkEXweU=";
      };
      Vault = pkgs.fetchurl {
        url = "https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar";
        sha256 = "prXtl/Q6XPW7rwCnyM0jxa/JvQA/hJh1r4s25s930B0=";
      };
      EssentialsX = pkgs.fetchurl {
        url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsX-2.20.1.jar";
        sha256 = "gC6jC9pGDKRZfoGJJYFpM8EjsI2BJqgU+sKNA6Yb9UI=";
      };
      EssentialsXChat = pkgs.fetchurl {
        url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXChat-2.20.1.jar";
        sha256 = "QKpcICQc6zAH68tc+/Gb8sRnsMCQrlDnBlPuh6t3XKY=";
      };
      EssentialsXProtect = pkgs.fetchurl {
        url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXProtect-2.20.1.jar";
        sha256 = "Mmj9Gin0Und8kgDofJyehYfcrtz/eP3ILZO22CznQSg=";
      };
      EssentialsXSpawn = pkgs.fetchurl {
        url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsXSpawn-2.20.1.jar";
        sha256 = "ZQ18ajOGWgLF/6TrcQ3vKOc9lyya74WysfTnG5vSYaA=";
      };
      WorldEdit = pkgs.fetchurl {
        url = "https://mediafilez.forgecdn.net/files/5830/450/worldedit-bukkit-7.3.8.jar";
        sha256 = "sR5AVGmHwcnF+K8ha7qJomWl/6yNzNkic/Yeu4YEBVY=";
      };
      WorldGuard = pkgs.fetchurl {
        url = "https://mediafilez.forgecdn.net/files/5719/698/worldguard-bukkit-7.0.12-dist.jar";
        sha256 = "SLE2k4s81IFqlYh4R/8o5WoG+xEBAzRLtXRznDX56Gw=";
      };
      CraftBook = pkgs.fetchurl {
        url = "https://mediafilez.forgecdn.net/files/5485/417/craftbook-3.10.11.jar";
        sha256 = "vgZ9epujY0lBhpe7LnE6rRSjFVlnHH2vZNB0klpjp0g=";
      };
      PCGF_PluginLib = pkgs.fetchurl {
        url = "https://ci.pcgamingfreaks.at/job/PluginLib/lastStableBuild/artifact/target/PCGF_PluginLib-1.0.39.7-SNAPSHOT.jar";
        sha256 = "RxIHOUjonp3szNZQCoLOx2rINW7UpaMyHT6a/QaiUpY=";
      };
      CodeBots = pkgs.fetchurl {
        url = "https://hangarcdn.papermc.io/plugins/alantr7/CodeBots/versions/0.1.2/PAPER/CodeBots-0.1.2.jar";
        sha256 = "ZKMTFpvDCSpwBg8fym5eGko4w6MpAk8tgarx1BvN21U=";
      };
      WorldEditSUI = pkgs.fetchurl {
        url = "https://hangarcdn.papermc.io/plugins/kennytv/WorldEditSUI/versions/1.7.4/PAPER/WorldEditSUI-1.7.4.jar";
        sha256 = "cAbPnllEx14bV8wZ3IjtF/wXmg4oNU/aQkqjKpWqw9g=";
      };
    });

  whiteList = {
    allocorn = "b2a3b7fb-e246-4d8e-8d44-166fe94a541d";
    BethyBee = "42cf9368-8fe6-44d8-85f3-2048526394c4";
    millipodd = "7f2cc2d7-e83b-4ace-a244-f61315f58468";
    Tendo_Tornado = "ec8308c2-4796-4e4f-81b9-a37930575e09";
    YaroKasear = "92f74cef-4495-491a-a0e0-d2f9806022d3";
  };
in
{
  options.united.minecraft =
    {
      enable = mkEnableOption "Minecraft";
    };

  config = mkIf cfg.enable {
    age.secrets = {
      "forwarding.secret" = {
        rekeyFile = secrets-directory + "forwarding.secret.age";
        path = "/var/forwarding.secret";
        symlink = false;
      };
      "secrets-file" = {
        rekeyFile = secrets-directory + "secrets-file.age";
        path = "/var/secrets-file";
        symlink = false;
      };
    };

    containers =
      let
        paper-config = (pkgs.formats.yaml { }).generate "paper-global.yml" {
          proxies = {
            velocity = {
              enabled = true;
              secret = "@fwsecret@";
            };
          };
        };
      in
      {
        minecraft-proxy =
          let
            proxy-config = (pkgs.formats.toml { }).generate "velocity.toml" {
              config-version = "2.7";
              bind = "0.0.0.0:25565";
              motd = "<#09add3>A Velocity Server";
              show-max-players = 500;
              online-mode = true;
              force-key-authentication = true;
              prevent-client-proxy-connections = false;
              player-info-forwarding-mode = "MODERN";
              forwarding-secret-file = "forwarding.secret";
              announce-forge = false;
              kick-existing-players = false;
              ping-passthrough = "DISABLED";
              enable-player-address-logging = true;

              servers = {
                lobby = "127.0.0.1:25000";
                creative = "127.0.0.1:25001";
                survival = "127.0.0.1:25002";
              };

              try = [ "lobby" ];
              forced-hosts = { };

              advanced = {
                compression-threshold = 256;
                compression-level = -1;
                login-ratelimit = 3000;
                connection-timeout = 5000;
                read-timeout = 30000;
                haproxy-protocol = false;
                tcp-fast-open = false;
                bungee-plugin-message-channel = true;
                show-ping-requests = false;
                failover-on-unexpected-server-disconnect = true;
                announce-proxy-commands = true;
                log-command-executions = false;
                log-player-connections = true;
                accepts-transfers = false;
              };

              query = {
                enabled = false;
                port = 25565;
                map = "Velocity";
                show-plugins = false;
              };
            };
          in
          {
            autoStart = true;
            specialArgs = { inherit inputs; };
            bindMounts = {
              "/etc/mc-proxy/forwarding.secret".hostPath = "/var/forwarding.secret";
            };
            config = { config, inputs, pkgs, ... }: {
              imports = [
                inputs.nix-minecraft.nixosModules.minecraft-servers
              ];

              nixpkgs = {
                overlays = [ inputs.nix-minecraft.overlay ];
                config.allowUnfree = true;
              };

              programs = {
                java.enable = true;
                bash.shellAliases.console = "tmux -S /run/mcproxy.sock attach";
              };

              environment = {
                etc = {
                  "mc-proxy/start.sh" = {
                    text = ''
                      #!/bin/sh

                      ${pkgs.tmux}/bin/tmux -S /run/mcproxy.sock new -d java -Xms1G -Xmx1G -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar velocity*.jar
                      ${pkgs.tmux}/bin/tmux -S /run/mcproxy.sock server-access -aw nobody
                      ${pkgs.coreutils}/bin/chmod 660 /run/mcproxy.sock
                    '';
                    mode = "0700";
                  };
                  "mc-proxy/velocity.toml" = {
                    source = proxy-config;
                    mode = "0600";
                  };
                  "mc-proxy/velocity.jar".source = "${inputs.nix-minecraft.packages.x86_64-linux.velocity-server}/lib/minecraft/server.jar";
                };
                systemPackages = [ pkgs.tmux ];
              };

              systemd.services.mcproxy = {
                path = [ config.programs.java.package ];
                script = ''
                  cd /etc/mc-proxy
                  ./start.sh
                '';
                preStop = ''
                  function server_running {
                    ${pkgs.tmux}/bin/tmux -S /run/mcproxy.sock has-session
                  }

                  if ! server_running ; then
                    exit 0
                  fi

                  ${pkgs.tmux}/bin/tmux -S /run/mcproxy.sock send-keys shutdown Enter

                  while server_running; do sleep 1s; done
                '';
                serviceConfig = {
                  Type = "forking";
                  GuessMainPID = true;
                };
                wantedBy = [ "multi-user.target" ];
              };

              users = {
                users.minecraft = {
                  uid = 3005;
                  group = "minecraft";
                  isSystemUser = true;
                };
                groups.minecraft.gid = 3007;
              };

              system.stateVersion = "unstable";
            };
          };

        creative = {
          autoStart = true;
          specialArgs = { inherit inputs; };
          bindMounts = {
            #  "/srv/minecraft/creative" = {
            #   hostPath = "/mnt/minecraft/creative";
            #   isReadOnly = false;
            "/etc/secrets-file".hostPath = "/var/secrets-file";
          };
          config = { config, inputs, pkgs, ... }: {
            imports = [
              inputs.nix-minecraft.nixosModules.minecraft-servers
            ];

            nixpkgs = {
              overlays = [ inputs.nix-minecraft.overlay ];
              config.allowUnfree = true;
            };

            environment.systemPackages = [ pkgs.tmux ];

            services.minecraft-servers = {
              enable = true;
              eula = true;
              openFirewall = true;
              environmentFile = "/etc/secrets-file";
              servers = {
                creative = {
                  enable = true;
                  autoStart = true;
                  # package = inputs.nix-minecraft.packages.x86_64-linux.paper-server;
                  package = inputs.nix-minecraft.legacyPackages.x86_64-linux.paperServers.paper-1_21_1-build_131;
                  whitelist = whiteList;
                  files."config/paper-global.yml" = paper-config;
                  extraStartPre = ''
                    mkdir -p /srv/minecraft/creative/plugins

                    for plugin in /srv/minecraft/creative/mods/*.jar; do
                      ln -sf "$plugin" /srv/minecraft/creative/plugins/
                    done
                  '';
                  serverProperties = {
                    gamemode = 1;
                    motd = "\\u00A7cHeartbeat\\u00A7r Communications \\u00A7n\\u00A7aCreative \\u00A7rWorld";
                    server-port = 25001;
                    level-seed = "4990696467101990762";
                  } // commonServerProperties;
                  symlinks.mods = commonMods;
                };
              };
            };

            programs.bash.shellAliases.console = "tmux -S /run/minecraft/creative.sock attach";

            users = {
              users.minecraft = {
                uid = 3005;
                group = "minecraft";
                isSystemUser = true;
              };
              groups.minecraft.gid = 3007;
            };

            system.stateVersion = "unstable";
          };
        };
        survival = {
          autoStart = true;
          specialArgs = { inherit inputs; };
          bindMounts = {
            #"/srv/minecraft/survival" = {
            #   hostPath = "/mnt/minecraft/survival";
            #   isReadOnly = false;
            "/etc/secrets-file".hostPath = "/var/secrets-file";
          };
          config = { config, inputs, pkgs, ... }: {
            imports = [
              inputs.nix-minecraft.nixosModules.minecraft-servers
            ];

            nixpkgs = {
              overlays = [ inputs.nix-minecraft.overlay ];
              config.allowUnfree = true;
            };

            environment.systemPackages = [ pkgs.tmux ];

            services.minecraft-servers = {
              enable = true;
              eula = true;
              openFirewall = true;
              environmentFile = "/etc/secrets-file";
              servers = {
                survival = {
                  enable = true;
                  autoStart = true;
                  package = inputs.nix-minecraft.legacyPackages.x86_64-linux.paperServers.paper-1_21_1-build_131;
                  whitelist = whiteList;
                  files."config/paper-global.yml" = paper-config;
                  extraStartPre = ''
                    mkdir -p /srv/minecraft/survival/plugins

                    for plugin in /srv/minecraft/survival/mods/*.jar; do
                      ln -sf "$plugin" /srv/minecraft/survival/plugins/
                    done
                  '';
                  serverProperties = {
                    gamemode = 0;
                    motd = "\\u00A7cHeartbeat\\u00A7r Communications \\u00A7n\\u00A79Survival \\u00A7rWorld";
                    pvp = false;
                    server-port = 25002;
                    level-seed = "-2226864637809564038";
                  } // commonServerProperties;
                  symlinks.mods = commonMods;
                };
              };
            };

            programs.bash.shellAliases.console = "tmux -S /run/minecraft/survival.sock attach";

            users = {
              users.minecraft = {
                uid = 3005;
                group = "minecraft";
                isSystemUser = true;
              };
              groups.minecraft.gid = 3007;
            };

            system.stateVersion = "unstable";
          };
        };
        lobby =
          {
            autoStart = true;
            specialArgs = { inherit inputs; };
            bindMounts = {
              #"/srv/minecraft/lobby" = {
              #   hostPath = "/mnt/minecraft/lobby";
              #   isReadOnly = false;
              "/etc/secrets-file".hostPath = "/var/secrets-file";
            };
            config = { config, inputs, pkgs, ... }: {
              imports = [
                inputs.nix-minecraft.nixosModules.minecraft-servers
              ];

              nixpkgs = {
                overlays = [ inputs.nix-minecraft.overlay ];
                config.allowUnfree = true;
              };

              environment.systemPackages = [ pkgs.tmux ];

              services.minecraft-servers = {
                enable = true;
                eula = true;
                openFirewall = true;
                environmentFile = "/etc/secrets-file";
                servers = {
                  lobby = {
                    enable = true;
                    autoStart = true;
                    package = inputs.nix-minecraft.legacyPackages.x86_64-linux.paperServers.paper-1_21_1-build_131;
                    whitelist = whiteList;
                    files."config/paper-global.yml" = paper-config;
                    extraStartPre = ''
                      mkdir -p /srv/minecraft/lobby/plugins

                      for plugin in /srv/minecraft/lobby/mods/*.jar; do
                        ln -sf "$plugin" /srv/minecraft/lobby/plugins/
                      done
                    '';
                    serverProperties = {
                      difficulty = 0;
                      gamemode = 2;
                      generate-structures = false;
                      level-type = "minecraft:flat";
                      motd = "\\u00A7cHeartbeat\\u00A7r Communications \\u00A7n\\u00A79Lobby";
                      pvp = false;
                      server-port = 25000;
                      spawn-animals = false;
                      spawn-monsters = false;
                      spawn-npcs = false;
                      max-world-size = 32;
                    } // commonServerProperties;
                    symlinks.mods = commonMods;
                  };
                };
              };

              programs.bash.shellAliases.console = "tmux -S /run/minecraft/lobby.sock attach";

              users = {
                users.minecraft = {
                  uid = 3005;
                  group = "minecraft";
                  isSystemUser = true;
                };
                groups.minecraft.gid = 3007;
              };

              system.stateVersion = "unstable";
            };
          };
      };

    networking.firewall.allowedTCPPorts = [ 25565 ];

    users = {
      users.minecraft = {
        uid = 3005;
        group = "minecraft";
        isSystemUser = true;
      };
      groups.minecraft.gid = 3007;
    };

    # Disabled for testing!
    # fileSystems."/mnt/minecraft" = {
    #   device = "storage.kasear.net:/mnt/data/server/deimos/minecraft";
    #   fsType = "nfs";
    #   options = [ "nfsvers=4.2" "_netdev" ];
    # };
  };
}
