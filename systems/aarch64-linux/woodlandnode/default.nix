{ config, inputs, lib, pkgs, ... }:
with lib;
with lib.united;

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

  SSID = "Heartbeat Communications - Main";
  SSIDpassword = "@psk@";
  interface = "wlan0";
  hostname = "woodlandnode";
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

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    initrd.systemd = disabled;
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
    };
    pam = disabled;
  };

  environment.systemPackages = with pkgs; [ vim ];

  services.openssh.enable = true;

  systemd.network = {
    enable = true;
    networks."10-wifi" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "ipv4";
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  hardware.enableRedistributableFirmware = true;
}
