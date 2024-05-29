{ lib, config, pkgs, inputs, ... }:
with lib;
with lib.united;
with inputs.nix-rice.lib.color;

let
  cfg = config.united.plasma;
in {
  options.united.plasma = {
    enable = mkEnableOption "Plasma";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        aha
        inputs.plasma-manager.packages.${pkgs.system}.rc2nix
      ];
      persistence = mkIf config.united.persistent.enable {
        "/persistent${config.united.user.directories.home}" =
        let
          mkHomeCanon = dir: lib.replaceStrings ["${config.united.user.directories.home}/"] [""] dir;

          cache-directory = mkHomeCanon config.united.user.directories.cache;
          config-directory = mkHomeCanon config.united.user.directories.config;
          data-directory = mkHomeCanon config.united.user.directories.data;
          state-directory = mkHomeCanon config.united.user.directories.state;
        in {
          directories = [
            "${data-directory}/kwalletd"
          ];
          files = [
            "${config-directory}/kwinoutputconfig.json"
            "${config-directory}/powerdevilrc"
          ];
        };
      };
    };

    programs.plasma = {
      enable = true;
      overrideConfig = true;

      fonts = rec {
        general = {
          family = config.united.style.fonts.interface;
          pointSize = 10;
        };
        fixedWidth = {
          family = config.united.style.fonts.terminal;
          pointSize = 10;
        };
        small = {
          family = config.united.style.fonts.interface;
          pointSize = 8;
        };
        toolbar = general;
        menu = general;
        windowTitle = general;
      };

      workspace = {
        clickItemTo = "select";
        wallpaper = "${config.united.style.wallpaper}";
      };

      configFile =
      with config.united.style.colors;
      let
        to-rgb-kde = color:
        let
          rgba = hexToRgba color;
        in
          "${toString (builtins.floor rgba.r)},${toString (builtins.floor rgba.g)},${toString (builtins.floor rgba.b)}";
      in {
        kdeglobals = {
          KDE.widgetStyle = "Fusion";
          General = {
            TerminalApplication = "kitty";
            TerminalService = "kitty.desktop";
            XftAntialias = true;
            XftHintStyle = "hintfull";
            XftSubPixel = "rgb";
          };
        };
        kwinrc = {
          Effect-blur.BlurStrength = 3;
          Effect-overview.BorderActivate = 9;
          MouseBindings.CommandTitlebarWheel = "Shade/Unshade";
          NightColor = {
            Active = true;
            LatitudeFixed = 42.0327;
            LongitudeFixed = -97.42;
            Mode = "Location";
          };
          Plugins = {
            fallapartEnabled = true;
            magiclampEnabled = true;
            sheetEnabled = true;
            slidebackEnabled = true;
          };
          Xwayland.Scale = 1;
        };
        ksmserverrc.General.loginMode = "emptySession";
      };
    };
  };
}
