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
        extraConfig = with config.united.style.colors; let
          activeForegroundColor = lib.replaceStrings ["#"] ["_"] active_tab_foreground;
          activeBackgroundColor = lib.replaceStrings ["#"] ["_"] active_tab_background;
          inactiveForegroundColor = lib.replaceStrings ["#"] ["_"] inactive_tab_foreground;
          inactiveBackgroundColor = lib.replaceStrings ["#"] ["_"] inactive_tab_background;
        in mkDefault ''
          enable_audio_bell yes
          window_alert_on_bell yes
          bell_on_tab "🔔 "
          bell_path ${home-directory}/.local/share/sound/bell.oga
          foreground ${foreground}
          background ${background}
          selection_foreground ${selection_foreground}
          selection_background ${selection_background}
          cursor ${cursor}
          cursor_text_color ${cursor_text_color}
          url_color ${url_color}
          visual_bell_color ${visual_bell_color}
          active_border_color ${active_border_color}
          inactive_border_color ${inactive_border_color}
          bell_border_color ${bell_border_color}
          active_tab_foreground ${active_tab_foreground}
          active_tab_background ${active_tab_background}
          inactive_tab_foreground ${inactive_tab_foreground}
          inactive_tab_background ${inactive_tab_background}
          tab_bar_background ${tab_bar_background}
          tab_bar_margin_color ${tab_bar_margin_color}
          mark1_background ${mark1_background}
          mark1_foreground ${mark1_foreground}
          mark2_background ${mark2_background}
          mark2_foreground ${mark2_foreground}
          mark3_background ${mark3_background}
          mark3_foreground ${mark3_foreground}
          color0 ${color0}
          color1 ${color1}
          color2 ${color2}
          color3 ${color3}
          color4 ${color4}
          color5 ${color5}
          color6 ${color6}
          color7 ${color7}
          color8 ${color8}
          color9 ${color9}
          color10 ${color10}
          color11 ${color11}
          color12 ${color12}
          color13 ${color13}
          color14 ${color14}
          color15 ${color15}
          background_opacity 0.5
          background_blur 32
          tab_bar_edge bottom
          tab_bar_align center
          tab_powerline_style round
          tab_bar_margin_width 9
          tab_bar_margin_height 9 0
          tab_bar_style separator
          tab_bar_min_tabs 2
          tab_separator ""
          tab_title_template "{fmt.fg.${inactiveBackgroundColor}}{fmt.bg.default}{fmt.fg.${inactiveForegroundColor}}{fmt.bg.${inactiveBackgroundColor}}{fmt.bold} {title.split()[0]} {fmt.fg.${inactiveBackgroundColor}}{fmt.bg.default} "
          active_tab_title_template "{fmt.fg.${activeBackgroundColor}}{fmt.bg.default}{fmt.fg.${activeForegroundColor}}{fmt.bg.${activeBackgroundColor}}{fmt.bold} {title.split()[0]} {fmt.fg.${activeBackgroundColor}}{fmt.bg.default} "
        '';
      };
    };
  };
}