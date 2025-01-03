{ lib, pkgs, inputs, config, ... }:
with lib;
with lib.united;
with config.home-manager.users;

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

in
{
  age = {
    identityPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ117s7oMUXt8PUsb5hlkbyGCdYgSHXdeaq7GQhFi5z7";
    };
    secrets = {
      cnelson-password.rekeyFile = secrets-directory + "cnelson-password.age";
      mosquitto-password = {
        rekeyFile = secrets-directory + "mosquitto-password.age";
        path = "/run/mosquitto-password";
        owner = "yaro";
        mode = "400";
        symlink = false;
      };
      "worlds.tf" = {
        rekeyFile = secrets-directory + "worlds.tf.age";
        path = "/run/worlds.tf";
        owner = "yaro";
        mode = "400";
        symlink = false;
      };
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    };
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    supportedFilesystems = [ "ntfs" ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = enabled;
    rstudio-server = {
      enable = true;
      package = pkgs.rstudioServerWrapper.override {
        packages = with pkgs.rPackages;
          [
            ggplot2
            Rcpp
            readxl
            tidyverse
          ];
      };
    };
    tailscale.extraUpFlags = [ "--exit-node=" ];
  };

  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
  };

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  united = {
    loki = enabled;
    common = {
      splash = false;
      banner = ''
        [90;40m░░░░░░░░░░░░░░░░░[0m
        [90;40m░[32m█[90m░░░[32m█▀█[90m░[32m█[90m░[32m█[90m░[32m▀[32m█▀[90m░[0m
        [90;40m░[32m█[90m░░░[32m█[90m░[32m█[90m░[32m█▀[32m▄[90m░░[32m█[90m░░[0m
        [90;40m░[32m▀▀▀[90m░[32m▀▀▀[90m░[32m▀[90m░[32m▀[90m░[32m▀[32m▀▀[90m░[0m
        [90;40m░░░░░░░░░░░░░░░░░[0m
      '';
    };
    desktop = {
      enable = true;
      use-wayland = true;
    };
    tailscale = enabled;
    wayland.compositor = "plasma";
  };

  networking.extraHosts = ''
    10.0.10.1 vpn.kasear.net
  '';

  systemd.coredump.enable = true;

  snowfallorg.users.cnelson.admin = false;

  users = {
    users = {
      cnelson = {
        hashedPasswordFile = config.age.secrets.cnelson-password.path;
        isNormalUser = true;
        shell = pkgs.zsh;
      };
      yaro.extraGroups = [ "video" "audio" "lp" "gamemode" "minecraft" "acme" ];
    };
    groups.minecraft.gid = 3007;
    groups.acme.gid = 3003;
  };

  united.minecraft = disabled;
}
