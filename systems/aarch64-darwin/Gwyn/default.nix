{ config, lib, pkgs, ... }:

{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  users.users.yaro = {
    home = "/Users/yaro";
    shell = pkgs.zsh;
  };
}