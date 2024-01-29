{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.git;
in {
  options.united.git = {
    enable = mkEnableOption "Git";
  };

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = "Yaro Kasear";
        userEmail = "yarokasear@gmail.com";
      };
      zsh.oh-my-zsh.plugins = mkIf config.united.zsh.enable [ "git" ];
    };
  };
}