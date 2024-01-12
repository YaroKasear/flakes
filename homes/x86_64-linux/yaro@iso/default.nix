{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    common.enable = true;
    desktop.enable = true;
  };

  programs = {
    firefox.enable = true;
  };

  services.nextcloud-client.enable = true;
}
