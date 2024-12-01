{ config, inputs, lib, pkgs, ... }:
with lib;
with lib.united;

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

  SSID = "Heartbeat Communications - Main";
  SSIDpassword = "@psk@";
  interface = "wlan0";
  hostname = "silvanus";
in
{
  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9GDqDSCLAeQB6VT+7wOnG81HLi1yaub+pnpQLOJCDq";
    };
    secrets = {
      wireless-secret.rekeyFile = secrets-directory + "wireless-secret.age";
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      environmentFile = config.age.secrets.wireless-secret.path;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };

  united = {
    common = {
      enable = true;
      mountFlake = false;
      banner = ''
        [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░[0m
        [90;40m░[32m█▀▀[90;40m░[32m▀█▀[90;40m░[32m█[90;40m░░░[32m█[90;40m░[32m█[90;40m░[32m█▀█[90;40m░[32m█▀█[90;40m░[32m█[90;40m░[32m█[90;40m░[32m█▀▀[90;40m░[0m
        [90;40m░[32m▀▀█[90;40m░░[32m█[90;40m░░[32m█[90;40m░░░[32m▀▄▀[90;40m░[32m█▀█[90;40m░[32m█[90;40m░[32m█[90;40m░[32m█[90;40m░[32m█[90;40m░[32m▀▀█[90;40m░[0m
        [90;40m░[32m▀▀▀[90;40m░[32m▀▀▀[90;40m░[32m▀▀▀[90;40m░░[32m▀[90;40m░░[32m▀[90;40m░[32m▀[90;40m░[32m▀[90;40m░[32m▀[90;40m░[32m▀▀▀[90;40m░[32m▀▀▀[90;40m░[0m
        [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░[0m
      '';
    };
    pam = disabled;
    tailscale = {
      enable = true;
      accept-connections = true;
      accept-dns = true;
      accept-routes = true;
    };
  };

  environment.systemPackages = with pkgs; [ vim ];

  programs.argon.one = enabled;

  services.openssh.enable = true;

  systemd.network = {
    enable = true;
    networks = {
      "10-ethernet" = {
        matchConfig.Name = "end0";
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "20-wifi" = {
        matchConfig.Name = "wlan0";
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  hardware = {
    deviceTree.filter = "bcm2711-rpi-4*.dtb";
    raspberry-pi."4" = {
      apply-overlays-dtmerge = enabled;
      xhci = enabled;
    };
  };
}
