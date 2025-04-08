{ config, lib, pkgs, ... }:
with lib;
with lib.united;

let
  cfg = config.united.sway;

in
{
  options.united.sway = {
    enable = mkEnableOption "Sway";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
    ];

    services = {
      gnome.gnome-keyring = enabled;
      seatd = enabled;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
            user = "greeter";
          };
        };
      };
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    users.users.yaro.extraGroups = [ "seat" ];
  };
}
