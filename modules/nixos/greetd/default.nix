{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.greetd;

  hyprConfig = pkgs.writeText "greetd-hypr-config" ''
    env=__GLX_VENDOR_LIBRARY_NAME,nvidia
    env=GBM_BACKEND,nvidia-drm
    env=LIBVA_DRIVER_NAME,nvidia
    env=QT_QPA_PLATFORMTHEME,qt5ct
    env=WLR_NO_HARDWARE_CURSORS,1
    env=WLR_DRM_NO_ATOMIC,1
    env=XCURSOR_SIZE,24
    env=XDG_CURRENT_DESKTOP=Hyprland
    env=XDG_SESSION_DESKTOP=Hyprland
    env=XDG_SESSION_TYPE,wayland
    env=__GL_GSYNC_ALLOWED,1

    misc {
      disable_hyprland_logo=true
    }

    exec-once = regreet; hyprctl dispatch exit
  '';

  kanshiConfig = pkgs.writeText "greetd-kanshi-config" ''
    profile {
      output "Dell Inc. Dell S2417DG #ASPupbpmjZPd" mode 2560x1440
    }
  '';
in {
  options.united.greetd = {
    enable = mkEnableOption "Greetd";
  };

  config = mkIf cfg.enable {
    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            # command = "Hyprland -c ${hyprConfig}";
            command = "cage -s -- sh -c 'kanshi -c ${kanshiConfig} & regreet'";
            user = "greeter";
          };
        };
        vt = 1;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        cage
        canta-theme
        greetd.regreet # Why isn't this installed with programs.regreet.enable = true?
        kanshi
        roboto
      ];
      variables = {
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };

    programs.regreet = {
      enable = true;
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
          font_name = "Roboto 16";
          theme_name = "Canta";
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      Hyprland
      zsh
      bash
    '';
  };
}
