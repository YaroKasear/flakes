{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;

  cfg = config.united.protonmail-bridge;
in {
  options.united.protonmail-bridge = {
    enable = mkEnableOption "ProtonMail Bridge!";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.protonmail-bridge ];

    systemd.user.services.protonmail-bridge = mkIf is-linux {
      Unit = {
        Description = "Protonmail Bridge";
        After = [ "network.target" ];
      };
      Service = {
        Restart = "always";
        Environment = "PATH=${pkgs.gnome3.gnome-keyring}/bin";
        ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --log-level info --noninteractive";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    launchd.agents.protonmail-bridge = mkIf is-darwin {
      enable = true;
      config = {
        Label = "protonmail-bridge";
        ProgramArguments = [
          "${pkgs.protonmail-bridge}/bin/protonmail-bridge"
          "--no-window"
          "--log-level"
          "info"
          "--noninteractive"
        ];
        RunAtLoad = true;
      };
    };
  };
}