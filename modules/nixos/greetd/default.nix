{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.greetd;

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
