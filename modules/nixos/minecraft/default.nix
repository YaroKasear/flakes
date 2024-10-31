{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.minecraft;

  commonServerPropperties = {
    force-gamemode = true;
    max-players = 5;
    player-idle-timeout = 600;
    white-list = true;
  };
in
{
  options.united.minecraft =
    {
      enable = mkEnableOption "Minecraft";

    };

  config = mkIf cfg.enable {
    containers =
      let
        whiteList = {
          allocorn = "b2a3b7fb-e246-4d8e-8d44-166fe94a541d";
          BethyBee = "42cf9368-8fe6-44d8-85f3-2048526394c4";
          millipodd = "7f2cc2d7-e83b-4ace-a244-f61315f58468";
          Tendo_Tornado = "ec8308c2-4796-4e4f-81b9-a37930575e09";
          YaroKasear = "92f74cef-4495-491a-a0e0-d2f9806022d3";
        };
      in
      {
        creative = {
          autoStart = true;
          specialArgs = { inherit inputs; };
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
              servers = {
                creative = {
                  enable = true;
                  autoStart = true;
                  package = inputs.nix-minecraft.packages.x86_64-linux.paper-server;
                  whitelist = whiteList;
                  serverProperties = {
                    gamemode = 1;
                    motd = "\\u00A7cHeartbeat\\u00A7r Communications \\u00A7n\\u00A7aCreative \\u00A7rWorld";
                    server-port = 25000;
                  } // commonServerPropperties;
                  symlinks.mods = pkgs.linkFarmFromDrvs "mods"
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
                    });
                };
              };
            };

            programs.bash.shellAliases = {
              console = "tmux -S /run/minecraft/creative.sock attach";
            };

            system.stateVersion = "24.05";
          };
        };
        survival = {
          autoStart = true;
          specialArgs = { inherit inputs; };
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
              servers = {
                survival = {
                  enable = true;
                  autoStart = true;
                  package = inputs.nix-minecraft.packages.x86_64-linux.paper-server;
                  whitelist = whiteList;
                  serverProperties = {
                    gamemode = 0;
                    motd = "\\u00A7cHeartbeat\\u00A7r Communications \\u00A7n\\u00A79Survival \\u00A7rWorld";
                    pvp = false;
                    server-port = 25001;
                  } // commonServerPropperties;
                  symlinks.mods = pkgs.linkFarmFromDrvs "mods"
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
                    });
                };
              };
            };

            programs.bash.shellAliases = {
              console = "tmux -S /run/minecraft/survival.sock attach";
            };

            system.stateVersion = "24.05";
          };
        };
      };

    networking.firewall.allowedTCPPorts = [
      25000
      25001
    ];
  };
}
