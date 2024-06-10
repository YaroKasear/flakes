{ lib, pkgs, ... }:
with lib.united;

{
  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      interval.Day = 7;
    };
    extraOptions = ''
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    enable = true;
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh = enabled;
  };

  services.nix-daemon = enabled;

  system.stateVersion = 4;

  users.users.yaro = {
    home = "/Users/yaro";
    shell = pkgs.zsh;
  };
}