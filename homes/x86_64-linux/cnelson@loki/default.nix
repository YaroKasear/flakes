{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    common.enable = true;
    desktop.enable = true;
    mattermost-desktop.enable = true;
    wayland.enable = true;
    user.name = "cnelson";
  };

  home = {
    packages = with pkgs; [
      diffuse
      (python3.withPackages(ps: with ps; [
        jinja2
        jupyter
        lxml
        pandas
      ]))
    ];
  };

  accounts = {
    email.accounts.Work = {
      primary = true;
      address = "cnelson@braunresearch.com";
      flavor = "gmail.com";
      realName = "Conrad Nelson";
      thunderbird.enable = true;
    };
    calendar.accounts.Work = {
      primary = true;
      remote = {
        type = "google_calendar";
        userName = "cnelson@braunresearch.com";
      };
    };
  };
}