{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ117s7oMUXt8PUsb5hlkbyGCdYgSHXdeaq7GQhFi5z7";
    };
    secrets = {
      cnelson-password.rekeyFile = secrets-directory + "cnelson-password.age";
      work-env = {
        rekeyFile = secrets-directory + "work-env.age";
        path = "${cnelson.united.user.directories.home}/.alysson-env";
        owner = "cnelson";
        mode = "400";
        symlink = false;
      };
      work-mysql-init = {
        rekeyFile = secrets-directory + "work-mysql-init.age";
        path = "/run/mysql-init";
        owner = "mysql";
        mode = "400";
        symlink = false;
      };
      work-npm = {
        rekeyFile = secrets-directory + "work-npm.age";
        path = "${cnelson.united.user.directories.home}/.npmrc";
        owner = "cnelson";
        mode = "400";
        symlink = false;
      };
      work-vpn.rekeyFile = secrets-directory + "work-vpn.age";
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
      yubikey-auth.rekeyFile = secrets-directory + "yubikey-auth.age";
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "cnelson";
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
    initialScript = config.age.secrets.work-mysql-init.path;
  };

  snowfallorg.users.cnelson.admin = false;

  united = {
    loki = enabled;
    common.splash = true;
    desktop = {
      enable = true;
      use-wayland = true;
    };
    wayland.compositor = "plasma";
  };

  users = {
    users = {
      yaro = {
        description = yaro.united.user.fullName;
        home = yaro.united.user.directories.home;
        isNormalUser = true;
        extraGroups = ["wheel" "video" "audio" "networkmanager" "lp" "gamemode" "systemd-journal"];
        shell = pkgs.zsh;
        hashedPasswordFile = config.age.secrets.yaro-password.path;
      };
      cnelson = {
        description = cnelson.united.user.fullName;
        home = cnelson.united.user.directories.home;
        isNormalUser = true;
        extraGroups = ["video" "audio" "lp"];
        shell = pkgs.zsh;
        hashedPasswordFile = config.age.secrets.cnelson-password.path;
      };
    };
  };
}
