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
      wireless-secret.rekeyFile = secrets-directory + "wireless-secret.age";
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

  networking.wireless = {
    enable = mkForce true;
    secretsFile = config.age.secrets.wireless-secret.path;
    networks."Heartbeat Communications - Main".pskRaw = "ext:psk";
    interfaces = [ "wlp7s0" ];
  };

  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = enabled;
    rstudio-server = {
      enable = false;
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

  systemd.network.networks."50-wifi" = {
    matchConfig.Name = "wlp2s0";
    networkConfig = {
      DHCP = "ipv4";
      LinkLocalAddressing = false;
      IPv6AcceptRA = false;
    };
    linkConfig.RequiredForOnline = "routable";
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
      yaro.extraGroups = [ "video" "audio" "lp" "gamemode" "minecraft" "acme" "wireshark" ];
    };
    # groups.minecraft.gid = 3007;
    groups.acme.gid = 3003;
  };

  environment.systemPackages = with pkgs; [ cudatoolkit inetutils ];

  united.minecraft = disabled;

  # EXPERIMENTAL STUFF BELOW

  programs.wireshark = enabled;
}
