{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.fzf;
in {
  options.united.fzf = {
    enable = mkEnableOption "Fzf";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (mkIf config.united.zsh.enable zsh-fzf-tab)
      (mkIf config.united.zsh.enable fzf-zsh)
    ];
    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = config.united.zsh.enable;
        colors = with config.united.style.colors; {
          fg = mkDefault foreground;
          bg = mkDefault background;
          "fg+" = mkDefault selection_foreground;
          "bg+" = mkDefault selection_background;
          hl = mkDefault white;
          preview-fg = mkDefault foreground;
          preview-bg = mkDefault background;
        };
        tmux.enableShellIntegration = true;
      };
      zsh = mkIf config.united.zsh.enable {
        oh-my-zsh = {
          plugins = [
            "fzf"
          ];
        };
        initExtra = ''
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        '';
      };
    };
  };
}