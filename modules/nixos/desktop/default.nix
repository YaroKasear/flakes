{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.desktop;
in {
  options.united.desktop = {
    enable = mkEnableOption "Desktop";
    use-wayland = mkEnableOption "Make use of Wayland instead of Xorg.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
      tmp.useTmpfs = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      polkit_gnome
      pulseaudio
    ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [pkgs.vulkan-validation-layers];
    };

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    programs.dconf = enabled;

    security.pam.services = {
      hyprlock = mkIf config.united.wayland.enable {};
      login = with config.security.pam.services.login.rules.auth; {
        rules.auth.gnome_keyring.order = u2f.order - 10;
	      u2fAuth = true;
      };
    };

    services = {
      xserver = {
        enable = mkDefault (!config.united.wayland.enable);
        xkb.layout = "us";
        displayManager.lightdm.enable = !config.united.wayland.enable;
        windowManager.i3 = {
          enable = true;
        };
      };
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        lowLatency = disabled; # https://github.com/fufexan/nix-gaming/issues/161
        pulse = enabled;
      };
      gnome.gnome-keyring = enabled;
      udev.extraRules = ''
        ACTION=="remove",\
        ENV{ID_BUS}=="usb",\
        ENV{ID_MODEL_ID}=="0407",\
        ENV{ID_VENDOR_ID}=="1050",\
        ENV{ID_VENDOR}=="Yubico",\
        RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

        ACTION=="add",\
        ENV{ID_BUS}=="usb",\
        ENV{ID_MODEL_ID}=="0407",\
        ENV{ID_VENDOR_ID}=="1050",\
        ENV{ID_VENDOR}=="Yubico",\
        ENV{ID_USB_SERIAL}=="Yubico_YubiKey_OTP+FIDO+CCID_0016751940",\
        RUN+="${pkgs.systemd}/bin/loginctl unlock-sessions"
      '';
    };

    sound = {
      enable = true;
      mediaKeys = enabled;
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    united.wayland.enable = cfg.use-wayland;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = mkIf (!config.united.wayland.enable) "*";
    };
  };
}
