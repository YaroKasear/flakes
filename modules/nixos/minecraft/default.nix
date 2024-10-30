{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.minecraft;
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
                    force-gamemode = true;
                    gamemode = 1;
                    server-port = 25000;
                    white-list = true;
                  };
                };
              };
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
                    force-gamemode = true;
                    gamemode = 0;
                    server-port = 25001;
                    white-list = true;
                  };
                };
              };
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
