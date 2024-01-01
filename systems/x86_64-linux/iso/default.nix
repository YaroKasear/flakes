{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
