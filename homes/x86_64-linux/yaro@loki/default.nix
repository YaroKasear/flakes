{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  nixpkgs.config.allowUnfree = true;

  united = {
    am2r.enable = true;
    common.enable = true;
    desktop.enable = true;
    i3.enable = true;
  };

  programs = {
    firefox.enable = true;
    vscode.enable = true;
  };

  services.nextcloud-client.enable = true;

  xdg.desktopEntries = {
    sonic3air = {
      name = "Sonic 3: Angel Island Revisited";
      genericName = "Sonic Fan Remaster of Sonic 3 & Knuckles";
      type = "Application";
      exec = "steam-run /mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux";
      terminal = false;
      categories = [ "Game" ];
      icon = "/mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux/data/icon.png";
    };
  };
}
