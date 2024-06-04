{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:
with lib.united;

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ117s7oMUXt8PUsb5hlkbyGCdYgSHXdeaq7GQhFi5z7";
    };
    secrets.yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    secrets.cnelson-password.rekeyFile = secrets-directory + "cnelson-password.age";
    secrets.work-vpn.rekeyFile = secrets-directory + "work-vpn.age";
    secrets.yubikey-auth.rekeyFile = secrets-directory + "yubikey-auth.age";
  };

  programs.adb = enabled;

  united = {
    loki = enabled;
    desktop = {
      enable = true;
      use-wayland = true;
    };
    wayland.compositor = "plasma";
  };

  users.users = {
    cnelson = {
      isNormalUser = true;
      extraGroups = ["video" "audio" "lp"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.age.secrets.cnelson-password.path;
    };
    yaro = {
      isNormalUser = true;
      extraGroups = ["wheel" "video" "audio" "networkmanager" "lp" "gamemode" "systemd-journal"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.age.secrets.yaro-password.path;
    };
  };
}
