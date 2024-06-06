{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.git;
in {
  options.united.git = {
    enable = mkEnableOption "Git";
    name = mkOpt types.str "Yaro Kasear" "Git username";
    email = mkOpt types.str "yarokasear@gmail.com" "Git email";
  };

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = cfg.name;
        userEmail = cfg.email;
      };
      zsh.oh-my-zsh.plugins = mkIf config.united.zsh.enable [ "git" ];
    };
  };
}