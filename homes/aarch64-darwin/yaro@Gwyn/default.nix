{ config, pkgs, lib, ... }:

{
  united = {
    git.enable = true;
    gnupg.enable = true;
  };
}