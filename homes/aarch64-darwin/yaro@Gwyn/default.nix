{ config, pkgs, lib, ... }:

{
  united = {
    admin.enable = true;
    common.enable = true;
    desktop.enable = true;
    kitty.enable = true;
  };
}