{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (lib.united) mkOpt enabled;

  cfg = config.united.style;
in {
  options.united.style = {
    enable = mkEnableOption "Style module!";
    # These are all based on kitty's color settings, which should allow for a more than rich enough selection!
    colors = {
      black = mkOpt types.str "${cfg.colors.black_dull}" "My black color!";
      red = mkOpt types.str "${cfg.colors.red_bright}" "My red color!";
      green = mkOpt types.str "${cfg.colors.green_bright}" "My green color!";
      yellow = mkOpt types.str "${cfg.colors.yellow_bright}" "My yellow color!";
      blue = mkOpt types.str "${cfg.colors.blue_bright}" "My blue color!";
      magenta = mkOpt types.str "${cfg.colors.magenta_bright}" "My magenta color!";
      cyan = mkOpt types.str "${cfg.colors.cyan_bright}" "My cyan color!";
      white = mkOpt types.str "${cfg.colors.white_bright}" "My white color!";

      black_dull = mkOpt types.str "${cfg.colors.color0}" "My black color!";
      black_bright = mkOpt types.str "${cfg.colors.color8}" "My black color!";
      red_dull = mkOpt types.str "${cfg.colors.color1}" "My red color!";
      red_bright = mkOpt types.str "${cfg.colors.color9}" "My red color!";
      green_dull = mkOpt types.str "${cfg.colors.color2}" "My green color!";
      green_bright = mkOpt types.str "${cfg.colors.color10}" "My green color!";
      yellow_dull = mkOpt types.str "${cfg.colors.color3}" "My yellow color!";
      yellow_bright = mkOpt types.str "${cfg.colors.color11}" "My yellow color!";
      blue_dull = mkOpt types.str "${cfg.colors.color4}" "My blue color!";
      blue_bright = mkOpt types.str "${cfg.colors.color12}" "My blue color!";
      magenta_dull = mkOpt types.str "${cfg.colors.color5}" "My magenta color!";
      magenta_bright = mkOpt types.str "${cfg.colors.color13}" "My magenta color!";
      cyan_dull = mkOpt types.str "${cfg.colors.color6}" "My cyan color!";
      cyan_bright = mkOpt types.str "${cfg.colors.color14}" "My cyan color!";
      white_dull = mkOpt types.str "${cfg.colors.color7}" "My white color!";
      white_bright = mkOpt types.str "${cfg.colors.color15}" "My white color!";

      foreground = mkOpt types.str "#dddddd" "My foreground color!";
      background = mkOpt types.str "${cfg.colors.black}" "My background color!";
      selection_foreground = mkOpt types.str "${cfg.colors.black}" "My selection_foreground color!";
      selection_background = mkOpt types.str "#fffacd" "My selection_background color!";

      cursor = mkOpt types.str "#cccccc" "My cursor color!";
      cursor_text_color = mkOpt types.str "#111111" "My cursor text color!";
      url_color = mkOpt types.str "#0087bd" "My URL color!";
      visual_bell_color = mkOpt types.str "${cfg.colors.selection_background}" "My visual bell color!";
      active_border_color = mkOpt types.str "#00ff00" "My active border color!";
      inactive_border_color = mkOpt types.str "#cccccc" "My inactive border color!";
      bell_border_color = mkOpt types.str "#ff5a00" "My bell border color!";
      active_tab_foreground = mkOpt types.str "${cfg.colors.black}" "My active tab foreground color!";
      active_tab_background = mkOpt types.str "#eeeeee" "My active tab background color!";
      inactive_tab_foreground = mkOpt types.str "#444444" "My inactive tab foreground color!";
      inactive_tab_background = mkOpt types.str "#999999" "My inactive tab background color!";
      tab_bar_background = mkOpt types.str "${cfg.colors.selection_background}" "My tab bar background color!";
      tab_bar_margin_color = mkOpt types.str "${cfg.colors.selection_background}" "My tab bar margin color!";

      mark1_background = mkOpt types.str "${cfg.colors.black}" "Mark 1 background color!";
      mark1_foreground = mkOpt types.str "#98d3cb" "Mark 1 foreground color!";
      mark2_background = mkOpt types.str "${cfg.colors.black}" "Mark 1 background color!";
      mark2_foreground = mkOpt types.str "#f2dcd3" "Mark 1 foreground color!";
      mark3_background = mkOpt types.str "${cfg.colors.black}" "Mark 1 background color!";
      mark3_foreground = mkOpt types.str "#f274bc" "Mark 1 foreground color!";

      color0 = mkOpt types.str "#000000" "Color 0";
      color1 = mkOpt types.str "#cc0403" "Color 1";
      color2 = mkOpt types.str "#19cb00" "Color 2";
      color3 = mkOpt types.str "#cecb00" "Color 3";
      color4 = mkOpt types.str "#0d73cc" "Color 4";
      color5 = mkOpt types.str "#cb1ed1" "Color 5";
      color6 = mkOpt types.str "#0dcdcd" "Color 6";
      color7 = mkOpt types.str "#dddddd" "Color 7";
      color8 = mkOpt types.str "#767676" "Color 8";
      color9 = mkOpt types.str "#f2201f" "Color 9";
      color10 = mkOpt types.str "#23fd00" "Color 10";
      color11 = mkOpt types.str "#fffd00" "Color 11";
      color12 = mkOpt types.str "#1a8fff" "Color 12";
      color13 = mkOpt types.str "#fd28ff" "Color 13";
      color14 = mkOpt types.str "#14ffff" "Color 14";
      color15 = mkOpt types.str "#ffffff" "Color 15";
      extraColors = mkOpt types.attrsOf types.str "Additional colors without any explicit role!";
    };
  };

  config = mkIf cfg.enable {
    gtk.enable = true;

    home.file = {
      "style.css".text = ''

      '';
    };
  };
}
