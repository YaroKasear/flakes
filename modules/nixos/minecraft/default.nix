{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.minecraft;
in
{
  options.united.minecraft = {
    enable = mkEnableOption "Minecraft";
  };

  config = mkIf cfg.enable {
    containers = {
      "minecraft-creative" = {
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
                whitelist = {
                  YaroKasear = "92f74cef-4495-491a-a0e0-d2f9806022d3";
                };
                serverProperties = {
                  force-gamemode = true;
                  gamemode = 1;
                  white-list = true;
                };
              };
              # proxy = {
              #   enable = true;
              #   package = pkgs.velocityServers.velocity;
              # };
            };
          };

          system.stateVersion = "24.05";
        };
      };
    };

    networking.firewall.allowedTCPPortRanges = [{
      from = 25001;
      to = 25000;
    }];
  };
}
