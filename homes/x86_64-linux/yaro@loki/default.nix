{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    am2r.enable = true;
    common.enable = true;
    desktop.enable = true;
    hyprland.enable = true;
    i3.enable = false;
    sonic3air.enable = true;
  };

  programs = {
    firefox.enable = true;
  };

  services.nextcloud-client.enable = true;
}
