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
      file.".face.icon".source = config.united.user.icon;
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
        colorScheme = mkDefault "BreezeDark";
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
          Desktops = {
            Id_1 = "c698a291-b9e2-4d58-804f-7939e0b0d748";
            Id_2 = "19f5a1ed-4506-4f91-9d50-8117011b1d43";
            Id_3 = "88ea78bd-94d7-4898-82f5-39310744f518";
            Id_4 = "682dae2d-0911-44e6-8e80-ad6580b91323";
            Number = 4;
            Rows = 2;
          };
          Effect-blur.BlurStrength = 3;
          Effect-overview.BorderActivate = 9;
          MouseBindings.CommandTitlebarWheel = "Shade/Unshade";
          NightColor = {
            Active = true;
            LatitudeFixed = 42.0327;
            LongitudeFixed = -97.42;
            Mode = "Location";
          };
          Xwayland.Scale = 1;

        };
        ksmserverrc.General.loginMode = "emptySession";
        kwinrulesrc = {
          "1" = {
            Description = "Window settings for firefox";
            above = true;
            aboverule = 3;
            skippager = true;
            skippagerrule = 3;
            skipswitcher = true;
            skipswitcherrule = 3;
            skiptaskbar = true;
            skiptaskbarrule = 3;
            title = "Picture-in-Picture";
            titlematch = 1;
            types = 1;
            wmclass = "firefox";
            wmclassmatch = 1;
          };
          General = {
            count = 1;
            rules = "25c18ec1-2987-44aa-8303-f50ccca0d237";
          };
        };
      };
    };
  };
}
