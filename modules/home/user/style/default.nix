{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (lib.united) mkOpt enabled;

  cfg = config.united.style;
in {
  options.united.style = {
    enable = mkEnableOption "Style module!";
    format = {
      interface-font = mkOpt types.str "FiraCode Nerd Font" "User interface font!";
      terminal-font = mkOpt types.str "FiraCode Nerd Font Mono" "Terminal font!";
    };
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

    home = {
      file = {
        "style/test.html".text = ''
          <html>
            <head>
              <title>United Flake Theme Test</title>
              <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
            </head>
            <body>
              <div class="container">
                <table class="table table-bordered my-5">
                  <thead>
                    <tr>
                      <th class="hiddenCell"></th>
                      <th>
                        Default
                      </th>
                      <th>
                        Dull
                      </th>
                      <th>
                        Bright
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr><th>Black</th><td style="background-color: ${cfg.colors.black};"></td><td style="background-color: ${cfg.colors.black_dull};"></td><td style="background-color: ${cfg.colors.black_bright};"></td></tr>
                    <tr><th>Red</th><td style="background-color: ${cfg.colors.red};"></td><td style="background-color: ${cfg.colors.red_dull};"></td><td style="background-color: ${cfg.colors.red_bright};"></td></tr>
                    <tr><th>Green</th><td style="background-color: ${cfg.colors.green};"></td><td style="background-color: ${cfg.colors.green_dull};"></td><td style="background-color: ${cfg.colors.green_bright};"></td></tr>
                    <tr><th>Yellow</th><td style="background-color: ${cfg.colors.yellow};"></td><td style="background-color: ${cfg.colors.yellow_dull};"></td><td style="background-color: ${cfg.colors.yellow_bright};"></td></tr>
                    <tr><th>Blue</th><td style="background-color: ${cfg.colors.blue};"></td><td style="background-color: ${cfg.colors.blue_dull};"></td><td style="background-color: ${cfg.colors.blue_bright};"></td></tr>
                    <tr><th>Magenta</th><td style="background-color: ${cfg.colors.magenta};"></td><td style="background-color: ${cfg.colors.magenta_dull};"></td><td style="background-color: ${cfg.colors.magenta_bright};"></td></tr>
                    <tr><th>Cyan</th><td style="background-color: ${cfg.colors.cyan};"></td><td style="background-color: ${cfg.colors.cyan_dull};"></td><td style="background-color: ${cfg.colors.cyan_bright};"></td></tr>
                    <tr><th>White</th><td style="background-color: ${cfg.colors.white};"></td><td style="background-color: ${cfg.colors.white_dull};"></td><td style="background-color: ${cfg.colors.white_bright};"></td></tr>
                    <tr><th>Foreground Color</th><td style="background-color: ${cfg.colors.foreground};"></td><th>Background Color</th><td style="background-color: ${cfg.colors.background};"></td></tr>
                    <tr><th>Selection Foreground</th><td style="background-color: ${cfg.colors.selection_foreground};"></td><th>Selection Background</th><td style="background-color: ${cfg.colors.selection_background};"></td></tr>
                    <tr><th>Cursor Color</th><td colspan="3" style="background-color: ${cfg.colors.cursor};"></td></tr>
                    <tr><th>Cursor Text Color</th><td colspan="3" style="background-color: ${cfg.colors.cursor_text_color};"></td></tr>
                    <tr><th>Url Color</th><td colspan="3" style="background-color: ${cfg.colors.url_color};"></td></tr>
                    <tr><th>Visual Bell Color</th><td colspan="3" style="background-color: ${cfg.colors.visual_bell_color};"></td></tr>
                    <tr><th>Active Border Color</th><td colspan="3" style="background-color: ${cfg.colors.active_border_color};"></td></tr>
                    <tr><th>Inactive Border Color</th><td colspan="3" style="background-color: ${cfg.colors.inactive_border_color};"></td></tr>
                    <tr><th>Bell Border Color</th><td colspan="3" style="background-color: ${cfg.colors.bell_border_color};"></td></tr>
                    <tr><th>Active Tab Foreground</th><td colspan="3" style="background-color: ${cfg.colors.active_tab_foreground};"></td></tr>
                    <tr><th>Active Tab Background</th><td colspan="3" style="background-color: ${cfg.colors.active_tab_background};"></td></tr>
                    <tr><th>Inactive Tab Foreground</th><td colspan="3" style="background-color: ${cfg.colors.inactive_tab_foreground};"></td></tr>
                    <tr><th>Inactive Tab Background</th><td colspan="3" style="background-color: ${cfg.colors.inactive_tab_background};"></td></tr>
                    <tr><th>Tab Bar Background</th><td colspan="3" style="background-color: ${cfg.colors.tab_bar_background};"></td></tr>
                    <tr><th>Tab Bar Margin Color</th><td colspan="3" style="background-color: ${cfg.colors.tab_bar_margin_color};"></td></tr>
                    <tr><th>Mark 1 Background</th><td style="background-color: ${cfg.colors.mark1_background};"></td><th>Mark 1 Foreground</th><td style="background-color: ${cfg.colors.mark1_foreground};"></td></tr>
                    <tr><th>Mark 2 Background</th><td style="background-color: ${cfg.colors.mark2_background};"></td><th>Mark 2 Foreground</th><td style="background-color: ${cfg.colors.mark2_foreground};"></td></tr>
                    <tr><th>Mark 3 Background</th><td style="background-color: ${cfg.colors.mark3_background};"></td><th>Mark 3 Foreground</th><td style="background-color: ${cfg.colors.mark3_foreground};"></td></tr>
                    <tr><th>color0</th><td style="background-color: ${cfg.colors.color0};"></td><th>color8</th><td style="background-color: ${cfg.colors.color8};"></td></tr>
                    <tr><th>color1</th><td style="background-color: ${cfg.colors.color1};"></td><th>color9</th><td style="background-color: ${cfg.colors.color9};"></td></tr>
                    <tr><th>color2</th><td style="background-color: ${cfg.colors.color2};"></td><th>color10</th><td style="background-color: ${cfg.colors.color10};"></td></tr>
                    <tr><th>color3</th><td style="background-color: ${cfg.colors.color3};"></td><th>color11</th><td style="background-color: ${cfg.colors.color11};"></td></tr>
                    <tr><th>color4</th><td style="background-color: ${cfg.colors.color4};"></td><th>color12</th><td style="background-color: ${cfg.colors.color12};"></td></tr>
                    <tr><th>color5</th><td style="background-color: ${cfg.colors.color5};"></td><th>color13</th><td style="background-color: ${cfg.colors.color13};"></td></tr>
                    <tr><th>color6</th><td style="background-color: ${cfg.colors.color6};"></td><th>color14</th><td style="background-color: ${cfg.colors.color14};"></td></tr>
                    <tr><th>color7</th><td style="background-color: ${cfg.colors.color7};"></td><th>color15</th><td style="background-color: ${cfg.colors.color15};"></td></tr>
                  </tbody>
                </table>
              </div>

              <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
            </body>
          </html>
        '';
      };
    };
  };
}