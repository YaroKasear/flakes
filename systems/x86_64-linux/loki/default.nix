{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  united = {
    loki.enable = true;
    desktop = {
      enable = true;
      use-wayland = true;
    };
  };

  users = {
    users.cnelson = {
      isNormalUser = true;
      extraGroups = ["video" "audio" "lp"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.hashedpw.path;
    };
  };
}
