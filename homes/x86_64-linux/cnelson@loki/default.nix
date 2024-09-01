{ lib, config, ... }:
with lib.united;

{
  united = {
    common = enabled;
    desktop = {
      enable = true;
      linux.waylandSupport = true;
    };
    wayland.compositor = "plasma";
    user = {
      name = "cnelson";
      fullName = "Conrad Nelson";
    };
    style = with config.united.style; {
      enable = true;
      catppuccin.frappe = enabled;
    };
  };

  programs.plasma.panels = [
    {
      location = "top";
      height = 32;
      widgets = [
        {
          name = "org.kde.plasma.userswitcher";
          config.General = {
            showFace = "true";
            showTechnicalInfo = "true";
          };
        }
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.panelspacer"
        "org.kde.plasma.marginsseparator"
        {
          systemTray.items = {
            shown = [
              "org.kde.plasma.volume"
            ];
            hidden = [
              "org.kde.plasma.bluetooth"
              "org.kde.plasma.networkmanagement"
            ];
          };
        }
        {
          digitalClock = {
            calendar.firstDayOfWeek = "sunday";
            time.format = "12h";
          };
        }
      ];
    }
    {
      location = "bottom";
      height = 64;
      lengthMode = "fit";
      hiding = "dodgewindows";
      floating = true;
      widgets = [
        {
          name = "org.kde.plasma.kickoff";
          config.General = {
            compactMode = "true";
            icon = "nix-snowflake-white";
          };
        }
        "org.kde.plasma.marginsseparator"
        {
          name = "org.kde.plasma.icontasks";
          config.General = {
            launchers = [
              "applications:systemsettings.desktop"
              "applications:org.kde.dolphin.desktop"
              "applications:kitty.desktop"
              "applications:firefox.desktop"
              "applications:code.desktop"
            ];
            groupingStrategy = "3";
            separateLaunchers = "false";
            showOnlyCurrentDesktop = "false";
          };
        }
        "org.kde.plasma.marginsseparator"
        {
          name = "org.kde.plasma.pager";
          config.General.currentDesktopSelected = "ShowDesktop";
        }
      ];
    }
  ];
}
