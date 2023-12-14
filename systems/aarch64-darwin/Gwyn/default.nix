{ config, lib, pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [ ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true; 
  };

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.yaro = {
    home = "/Users/yaro";
    shell = pkgs.zsh;
  };
}