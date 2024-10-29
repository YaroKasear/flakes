{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.minecraft;
in
{
  options.united.minecraft = {
    enable = mkEnableOption "minecraft";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      servers = {
        creative = {
          enable = true;
          package = pkgs.papermcServers.papermc;
          whitelist = {
            YaroKasear = "92f74cef-4495-491a-a0e0-d2f9806022d3";
          };
          serverProperties = {
            force-gamemode = true;
            gamemode = 0;
            server-port = 25567;
            white-list = true;
          };
        };
      };
    };
  };
}
