{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    common.enable = false;
    user.name = "cnelson";
  };

  home.stateVersion = "23.11";
}