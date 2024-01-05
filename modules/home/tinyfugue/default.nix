{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (config.united) user;

  cfg = config.united.tinyfugue;

  worldModule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
      };
      host = mkOption {
        type = types.str;
      };
      port = mkOption {
        type = types.ints.u16;
      };
      characters = mkOption {
        type = types.listOf characterModule;
        default = [ ];
      };
    };
  };

  characterModule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
      };
      password = mkOption {
        type = types.str;
      };
    };
  };

  generateTFRC = worlds: let
    addCharacter = world: character:
      "/addworld ${replaceStrings [" "] ["_"] world.name}.${character.name} ${character.name} \"${character.password}\" ${world.host} ${toString world.port}";

    addWorld = world:
      concatStringsSep "\n" (map (addCharacter world) world.characters);
  in
    concatStringsSep "\n" (map addWorld worlds);
in
  {
  options.united.tinyfugue = {
    enable = mkEnableOption "Tinyfugue";
    worlds = mkOption {
      type = types.listOf worldModule;
      default = [ ];
    };
    extraConfig = mkOption {
      type = types.str;
      default = ''
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
        /def -mregexp -t".*In a page-pose to you, .*.*" alert_page_post = /repeat -0.5 2 /beep
        /def -mregexp -t".*Na'go'zi.*" alert_ngz = /repeat -0.5 2 /beep
        /def -mregexp -t".*wizzes.*" alert_wizzes = /repeat -0.5 2 /beep
        /def -mregexp -t".*fc-chat.*" alert_fc = /repeat -0.5 2 /beep
        /def -mregexp -t".*plc-chat.*" alert_plc = /repeat -0.5 2 /beep
        /def -mregexp -t".*Hutolewa.*" alert_htw = /repeat -0.5 2 /beep
        /def -mregexp -t".* would like to join you." alert_mjoin = /repeat -0.5 2 /beep
        /def -mregexp -t".* has connected." alert_connect = /repeat -0.1 10 /beep
        /def -mregexp -t"It is now your pose." alert_poseorder = /repeat -0.1 10 /beep
        /def -mregexp -t".* has arrived." alert_arrive = /repeat -0.1 10 /beep
        /def -mregexp -t".* has disconnected." alert_disconnect = /repeat -0.1 5 /beep
        /def -mregexp -t".* has left." alert_left = /repeat -0.1 5 /beep
        /def -mregexp -t".* says, .*" alert_say = /beep
        /def -mregexp -t"\[OOC\].*" alert_ooc = /repeat -0.1 2 /beep
        /def -mregexp -t".*Ketekh.*" alert_ketekh = /repeat -0.1 2 /beep
        /def -mregexp -t".*Yaro.*" alert_yaro = /repeat -1 2 /beep
        /def -mregexp -t".*Kubwini.*" alert_kubwini = /repeat -1 2 /beep
        /def -mregexp -t".*Tamani.*" alert_tamani = /repeat -1 2 /beep
        /def -mregexp -t".*Ukarimu.*" alert_ukarimu = /repeat -1 2 /beep
        /def -mregexp -t".*Bikira.*" alert_bikira = /repeat -1 2 /beep
        /def -mregexp -t".*Morowa.*" alert_morowa = /repeat -1 2 /beep
        /def -mregexp -t".*Tofauti.*" alert_tofauti = /repeat -1 2 /beep
        /def -mregexp -t".*Wanachi.*" alert_wanachi = /repeat -1 2 /beep
        /def -mregexp -t".*Taya.*" alert_taya = /repeat -1 2 /beep
        /def -mregexp -t".* tried to page you." alert_blocked = /repeat -0.1 30 /beep
        /def -mregexp -t".*CCS request.*" alert_ccs = /repeat -0.1 30 /beep

        /def -mregexp -t"> Guest(\d) has connected.*" -F -p2 = /repeat -10 1 page guest%P1 = Hello! Welcome to -x TLK MUCK! Please let me know of any questions! Use the command 'page wanachi="message"' without the single quotes to do so!
        /def -mregexp -t"> Guest(\d) has connected.*" -p1 = /repeat -0.1 30 /beep

        /load -q ~/.worlds.tf
      '';
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [
        tinyfugue
      ];
      # Nice as this is, the only option I have with this is storing passwords
      # in plain-text. Might work on this.
      file = {
        ".tfrc".text = ''
          ${generateTFRC cfg.worlds}


          ${cfg.extraConfig}
        '';
      };
    };

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      gnupg = {
        home = "/home/yaro/.gnupg";
        sshKeyPaths = [];
      };
      secrets.worlds-tf.path = ".worlds.tf";
    };
  };
}
