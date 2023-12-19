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
      default = "";
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
