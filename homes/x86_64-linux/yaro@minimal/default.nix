{ lib, ... }:

with lib.united;
{
  home.stateVersion = "24.05";

  programs = {
    home-manager = enabled;
    zsh = enabled;
  };

  united = {
    git = enabled;
  };
}
