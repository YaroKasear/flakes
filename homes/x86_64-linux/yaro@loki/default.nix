{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  nixpkgs.config.allowUnfree = true;

  united = {
    am2r.enable = true;
    common.enable = true;
    desktop.enable = true;
    i3.enable = true;
    sonic3air.enable = true;
  };

  programs = {
    firefox.enable = true;
  };

  services.nextcloud-client.enable = true;
}
