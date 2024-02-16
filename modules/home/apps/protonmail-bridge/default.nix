{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.protonmail-bridge;
in {
  options.united.protonmail-bridge = {
    enable = mkEnableOption "ProtonMail Bridge!";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.protonmail-bridge ];

    systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "Protonmail Bridge";
        After = [ "network.target" ];
      };
      Service = {
        Restart = "always";
        Environment = "PATH=${pkgs.gnome3.gnome-keyring}/bin";
        ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --log-level ${cfg.logLevel}" + optionalString (cfg.nonInteractive) " --noninteractive";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}