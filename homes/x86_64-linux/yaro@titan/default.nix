{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    admin.enable = true;
    common.enable = true;
  };

  nix.package = pkgs.nixVersions.latest; # Fixes an update in upstread nixpkgs that breaks home-manager standalone configurations in this flake.
}
