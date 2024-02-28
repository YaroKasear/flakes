{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  united = {
    loki.enable = true;
    desktop = {
      enable = true;
      use-wayland = false;
    };
  };

  users.users = {
    yaro = {
      isNormalUser = true;
      extraGroups = ["wheel" "video" "audio" "networkmanager" "lp" "gamemode" "systemd-journal"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.hashedpw.path;
    };
  };

  sops = {
    secrets = {
      authfile.sopsFile = ./secrets.yaml;
      hashedpw = {
        neededForUsers = true;
        sopsFile = ./secrets.yaml;
      };
    };
  };
}
