{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  nix.package = pkgs.nixVersions.latest;

  united = {
    admin.enable = true;
    common.enable = true;
  };
}
