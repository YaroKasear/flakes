{ config, lib, pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [ ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;  # default shell on catalina

  system.configurationRevision = config.rev or config.dirtyRev or null;

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.yaro = {
    home = "/Users/yaro";
    shell = pkgs.zsh;
  };
}