{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  home-directory = config.united.user.home-directory;

  cfg = config.united.kitty;
in {
  options.united.kitty = {
    enable = mkEnableOption "Kitty";
  };

  config = mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font";
          package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
        };
        shellIntegration = {
          enableBashIntegration = true;
          enableZshIntegration = true;
        };
        extraConfig = with config.united.user.colors; let
          primaryColor = lib.replaceStrings ["#"] ["_"] primary;
          secondaryColor = lib.replaceStrings ["#"] ["_"] secondary;
          tertiaryColor = lib.replaceStrings ["#"] ["_"] tertiary;
        in ''
          enable_audio_bell yes
          window_alert_on_bell yes
          bell_on_tab "🔔 "
          bell_path ${home-directory}/.local/share/sound/bell.oga
          foreground ${primary}
          background ${tertiary}
          background_opacity 0.8
          background_blur 32
          tab_bar_edge bottom
          tab_bar_align center
          tab_powerline_style round
          tab_bar_margin_width 9
          tab_bar_margin_height 9 0
          tab_bar_style separator
          tab_bar_min_tabs 1
          tab_separator ""
          tab_title_template "{fmt.fg.${secondaryColor}}{fmt.bg.default}{fmt.fg.${primaryColor}}{fmt.bg.${secondaryColor}} {title.split()[0]} {fmt.fg.${secondaryColor}}{fmt.bg.default} "
          active_tab_title_template "{fmt.fg.${primaryColor}}{fmt.bg.default}{fmt.fg.${secondaryColor}}{fmt.bg.${primaryColor}} {title.split()[0]} {fmt.fg.${primaryColor}}{fmt.bg.default} "
        '';
      };
    };
  };
}