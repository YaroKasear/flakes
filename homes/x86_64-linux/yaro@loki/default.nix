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
    tinyfugue = {
      enable = true;
      extraConfig = ''
        /def -i putfile = /putfile_MUCK %*

        /def -i putfile_MUCK =\
            @edit %{2-%{1}}%;\
            1 99999 d%;\
            i%;\
            /quote -S '%1%;\
            .%;\
            c%;\
            q

        /def -i getfile_MUCK =\
            /def -i -w -1 -aG -p98 -msimple -t"Editor exited." _getfile_end =\
                /log -w OFF%%;\
                /undef _getfile_quiet%;\
            /def -i -w -1 -p99 -msimple -t"Entering editor." _getfile_start =\
                /sys rm -f '%1'%%;\
                /log -w %1%%;\
                /def -i -w -p97 -ag -mglob -t"*" _getfile_quiet%;\
            @edit %{2-%{1}}%;\
            1 99999 l%;\
            q

        /def log_session = /log -w$[world_info()] ~/Personal Cloud/tflogs/$[world_info()]-$[ftime("%Y-%m-%d", time())]-loki.txt
        /def -F -hCONNECT start_logging = /log_session

        /repeat -1800 i wf

        /def -mregexp -t"> Guest(\d) has connected.*" -F -p2 = /repeat -10 1 page guest%P1 = Hello! Welcome to -x TLK MUCK! Please let me know of any questions! Use the command 'page wanachi="message"' without the single quotes to do so!
        /def -mregexp -t"> Guest(\d) has connected.*" -p1 = /repeat -0.1 30 /bee

        /load -q ~/.worlds.tf
      '';
    };
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
