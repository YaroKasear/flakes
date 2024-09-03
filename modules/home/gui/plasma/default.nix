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
      file = {
        ".face.icon".source = config.united.user.icon;
        ".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
      };
      packages = with pkgs; [
        aha
        inputs.plasma-manager.packages.${pkgs.system}.rc2nix
        config.united.style.fonts.interface.package
        config.united.style.fonts.terminal.package
      ];
      persistence = mkIf config.united.persistent.enable {
        "/persistent${config.united.user.directories.home}" =
        let
          mkHomeCanon = dir: lib.replaceStrings ["${config.united.user.directories.home}/"] [""] dir;

          config-directory = mkHomeCanon config.united.user.directories.config;
          data-directory = mkHomeCanon config.united.user.directories.data;
        in {
          directories = [
            "${data-directory}/kwalletd"
          ];
          files = [
            "${config-directory}/kwinoutputconfig.json"
          ];
        };
      };
    };

    programs = {
      firefox.package = pkgs.firefox.override {
        cfg.nativeMessagingHosts.packages = [pkgs.kdePackages.plasma-browser-integration];
      };
      plasma = {
        enable = true;
        overrideConfig = true;

        fonts = rec {
          general = {
            family = config.united.style.fonts.interface.name;
            pointSize = config.united.style.fonts.interface.size;
          };
          fixedWidth = {
            family = config.united.style.fonts.terminal.name;
            pointSize = config.united.style.fonts.terminal.size;
          };
          small = {
            family = config.united.style.fonts.interface.name;
            pointSize = config.united.style.fonts.interface.size - 2;
          };
          toolbar = general;
          menu = general;
          windowTitle = general;
        };

        input.keyboard.numlockOnStartup = "on";

        kwin = {
          virtualDesktops = {
            number = 4;
            names = [
              "Main"
              "Multimedia"
              "System & Programming"
              "Gaming"
            ];
            rows = 2;
          };
          effects = {
            blur = enabled;
            desktopSwitching.animation = "slide";
            wobblyWindows = enabled;
          };
          nightLight = {
            enable = true;
            location = {
              latitude = "42.0327";
              longitude = "-97.42";
            };
            mode = "location";
          };
          titlebarButtons.left = [];
        };

        powerdevil.AC = {
          powerButtonAction = "shutDown";
          autoSuspend.action = "nothing";
          turnOffDisplay.idleTimeout = "never";
        };

        window-rules = [
          {
            description = "Firefox Picture-In-Picture";
            match = {
              title = "Picture-in-Picture";
              window-class = {
                value = "firefox";
                type = "substring";
              };
              window-types = ["normal"];
            };
            apply = {
              above = true;
              desktops = true;
              skippager = true;
              skipswitcher = true;
              skiptaskbar = true;
            };
          }
        ];

        workspace = {
          clickItemTo = "select";
          wallpaper = "${config.united.style.wallpaper}";
          colorScheme = mkDefault "BreezeDark";
        };

        configFile = {
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
            Effect-overview.BorderActivate = 9;
            MouseBindings.CommandTitlebarWheel = "Shade/Unshade";
            Xwayland.Scale = 1;
          };
          ksmserverrc.General.loginMode = "emptySession";
        };
      };
    };
  };
}
