{ config, inputs, lib, pkgs, ... }:
with lib;
with lib.united;

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

  # SSID = "Heartbeat Communications - Main";
  # SSIDpassword = "@psk@";
  # interface = "wlan0";
  hostname = "silvanus";
in
{
  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9GDqDSCLAeQB6VT+7wOnG81HLi1yaub+pnpQLOJCDq";
    };
    secrets = {
      # wireless-secret.rekeyFile = secrets-directory + "wireless-secret.age";
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    };
  };

  boot.loader.systemd-boot = disabled;
  boot.initrd.systemd.tpm2 = disabled;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = hostname;
    # wireless = {
    #   enable = true;
    #   environmentFile = config.age.secrets.wireless-secret.path;
    #   networks."${SSID}".psk = SSIDpassword;
    #   interfaces = [ interface ];
    # };
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
      # "20-wifi" = {
      #   matchConfig.Name = "wlan0";
      #   networkConfig = {
      #     DHCP = "ipv4";
      #     LinkLocalAddressing = false;
      #     IPv6AcceptRA = false;
      #   };
      #   linkConfig.RequiredForOnline = "routable";
      # };
    };
  };

  systemd = {
    services.runtest = {
      path = [
        pkgs.coreutils
        pkgs.gawk
        pkgs.iw
        pkgs.speedtest-cli
      ];
      script =
        let
          storage-path = config.users.users.yaro.home;
          num-tests = 3;
          samples = 10;
        in
        ''
          #!${pkgs.bash}/bin/bash

          COUNTER_FILE=${storage-path}/$(cat /proc/sys/kernel/random/boot_id)-counter
          NUM_TESTS=${toString num-tests}

          TEST_FILE=${storage-path}/$(cat /proc/sys/kernel/random/boot_id)-speedtest.csv

          if [ ! -f $COUNTER_FILE ]; then
            echo 0 > $COUNTER_FILE
          fi

          COUNTER=$(cat $COUNTER_FILE)

          if [ ! -f $TEST_FILE ]; then
            echo "Link,Level,Noise,BSSID,TX Bitrate,RX Bitrate,$(speedtest --csv-header)" > $TEST_FILE
          fi

          for i in {1..${toString samples}}
          do
            link_level_noise=$(awk 'NR==3 {gsub(/\./, "", $3); gsub(/\./, "", $4); gsub(/\./, "", $5); print $3","$4","$5}' /proc/net/wireless)
            bssid_and_bitrate=$(iw dev wlp7s0 link | awk '/Connected/ {bssid=$3} /tx bitrate/ {tx=$3} /rx bitrate/ {rx=$3} END {print bssid","tx","rx}')
            speed_results=$(speedtest --csv)

            echo "$link_level_noise,$bssid_and_bitrate,$speed_results" >> $(cat /proc/sys/kernel/random/boot_id)-speedtest.csv
          done
        '';
    };
    timers.runtest = {
      after = [ "systemd-networkd-wait-online.service" ];
    };
  };
}
