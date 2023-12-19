{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  nixpkgs.config.allowUnfree = true;

  united = {
    blightmud.enable = false;
    common.enable = true;
    i3.enable = true;
    mpv.enable = true;
    thunderbird.enable = true;
    tinyfugue.enable = true;
  };

  home = {
    packages = with pkgs;
    [
      bitwarden
      diffuse
      discord
      dotnet-runtime
      libreoffice-fresh
      mattermost-desktop
      mpvScripts.mpris
      neofetch
      nerdfonts
      powerline-fonts
      scrot
      skypeforlinux
      steam-run
      telegram-desktop
      tinyfugue
      traceroute
      virt-manager
      yubioath-flutter
    ];
  };

  programs = {
    firefox.enable = true;
    vscode.enable = true;
  };

  services.nextcloud-client.enable = true;

  xdg.desktopEntries = {
    sonic3air = {
      name = "Sonic 3: Angel Island Revisited";
      genericName = "Sonic Fan Remaster of Sonic 3 & Knuckles";
      type = "Application";
      exec = "steam-run /mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux";
      terminal = false;
      categories = [ "Game" ];
      icon = "/mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux/data/icon.png";
    };
    am2r = {
      name = "Another Metroid 2 Remake";
      genericName = "Metroid Fan Remake of Metroid 2: Return of Samus";
      type = "Application";
      exec = "steam-run  /mnt/games/Another\\ Metroid\\ 2\\ Remake/runner";
      terminal = false;
      categories = [ "Game" ];
      icon = "/mnt/games/Another\\ Metroid\\ 2\\ Remake/icon.png";
    };
  };
}
