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

    home.file = {
      "style/test.html".text = ''
        <html>
          <head>
            <style>
              :root {
                --black: ${cfg.colors.black};
                --red: ${cfg.colors.red};
                --green: ${cfg.colors.green};
                --yellow: ${cfg.colors.yellow};
                --blue: ${cfg.colors.blue};
                --magenta: ${cfg.colors.magenta};
                --cyan: ${cfg.colors.cyan};
                --white: ${cfg.colors.white};
                --black_dull: ${cfg.colors.black_dull};
                --black_bright: ${cfg.colors.black_bright};
                --red_dull: ${cfg.colors.red_dull};
                --red_bright: ${cfg.colors.red_bright};
                --green_dull: ${cfg.colors.green_dull};
                --green_bright: ${cfg.colors.green_bright};
                --yellow_dull: ${cfg.colors.yellow_dull};
                --yellow_bright: ${cfg.colors.yellow_bright};
                --blue_dull: ${cfg.colors.blue_dull};
                --blue_bright: ${cfg.colors.blue_bright};
                --magenta_dull: ${cfg.colors.magenta_dull};
                --magenta_bright: ${cfg.colors.magenta_bright};
                --cyan_dull: ${cfg.colors.cyan_dull};
                --cyan_bright: ${cfg.colors.cyan_bright};
                --white_dull: ${cfg.colors.white_dull};
                --white_bright: ${cfg.colors.white_bright};
                --foreground: ${cfg.colors.foreground};
                --background: ${cfg.colors.background};
                --selection_foreground: ${cfg.colors.selection_foreground};
                --selection_background: ${cfg.colors.selection_background};
                --cursor: ${cfg.colors.cursor};
                --cursor_text_color: ${cfg.colors.cursor_text_color};
                --url_color: ${cfg.colors.url_color};
                --visual_bell_color: ${cfg.colors.visual_bell_color};
                --active_border_color: ${cfg.colors.active_border_color};
                --inactive_border_color: ${cfg.colors.inactive_border_color};
                --bell_border_color: ${cfg.colors.bell_border_color};
                --active_tab_foreground: ${cfg.colors.active_tab_foreground};
                --active_tab_background: ${cfg.colors.active_tab_background};
                --inactive_tab_foreground: ${cfg.colors.inactive_tab_foreground};
                --inactive_tab_background: ${cfg.colors.inactive_tab_background};
                --tab_bar_background: ${cfg.colors.tab_bar_background};
                --tab_bar_margin_color: ${cfg.colors.tab_bar_margin_color};
                --mark1_background: ${cfg.colors.mark1_background};
                --mark1_foreground: ${cfg.colors.mark1_foreground};
                --mark2_background: ${cfg.colors.mark2_background};
                --mark2_foreground: ${cfg.colors.mark2_foreground};
                --mark3_background: ${cfg.colors.mark3_background};
                --mark3_foreground: ${cfg.colors.mark3_foreground};
                --color0: ${cfg.colors.color0};
                --color1: ${cfg.colors.color1};
                --color2: ${cfg.colors.color2};
                --color3: ${cfg.colors.color3};
                --color4: ${cfg.colors.color4};
                --color5: ${cfg.colors.color5};
                --color6: ${cfg.colors.color6};
                --color7: ${cfg.colors.color7};
                --color8: ${cfg.colors.color8};
                --color9: ${cfg.colors.color9};
                --color10: ${cfg.colors.color10};
                --color11: ${cfg.colors.color11};
                --color12: ${cfg.colors.color12};
                --color13: ${cfg.colors.color13};
                --color14: ${cfg.colors.color14};
                --color15: ${cfg.colors.color15};
              }

              * {
                background-color: var(--background);
                border-color: var(--active_border_color);
                box-sizing: border-box;
                color: var(--foreground);
                font-family: ${cfg.format.interface-font}, sans-serif;
              }

              .border {
                border: 1px solid;
              }

              .fg-default {
                color: var(--background);
              }

              .bg-default {
                background-color: var(--foreground);
              }

              .border-default {
                border: 1px solid var(--active_border_color);
              }

              .fg-black {
                color: var(--black);
              }

              .bg-black {
                background-color: var(--black);
              }

              .border-black {
                border: 1px solid var(--black);
              }

              .border-black {
                border-color: var(--black);
              }

              .shadow-black {
                box-shadow: .5em .5em .25em var(--black);
              }

              .fg-red {
                color: var(--red);
              }

              .bg-red {
                background-color: var(--red);
              }

              .border-red {
                border: 1px solid var(--red);
              }

              .border-red {
                border-color: var(--red);
              }

              .shadow-red {
                box-shadow: .5em .5em .25em var(--red);
              }

              .fg-green {
                color: var(--green);
              }

              .bg-green {
                background-color: var(--green);
              }

              .border-green {
                border: 1px solid var(--green);
              }

              .border-green {
                border-color: var(--green);
              }

              .shadow-green {
                box-shadow: .5em .5em .25em var(--green);
              }

              .fg-yellow {
                color: var(--yellow);
              }

              .bg-yellow {
                background-color: var(--yellow);
              }

              .border-yellow {
                border: 1px solid var(--yellow);
              }

              .border-yellow {
                border-color: var(--yellow);
              }

              .shadow-yellow {
                box-shadow: .5em .5em .25em var(--yellow);
              }

              .fg-blue {
                color: var(--blue);
              }

              .bg-blue {
                background-color: var(--blue);
              }

              .border-blue {
                border: 1px solid var(--blue);
              }

              .border-blue {
                border-color: var(--blue);
              }

              .shadow-blue {
                box-shadow: .5em .5em .25em var(--blue);
              }

              .fg-magenta {
                color: var(--magenta);
              }

              .bg-magenta {
                background-color: var(--magenta);
              }

              .border-magenta {
                border: 1px solid var(--magenta);
              }

              .border-magenta {
                border-color: var(--magenta);
              }

              .shadow-magenta {
                box-shadow: .5em .5em .25em var(--magenta);
              }

              .fg-cyan {
                color: var(--cyan);
              }

              .bg-cyan {
                background-color: var(--cyan);
              }

              .border-cyan {
                border: 1px solid var(--cyan);
              }

              .border-cyan {
                border-color: var(--cyan);
              }

              .shadow-cyan {
                box-shadow: .5em .5em .25em var(--cyan);
              }

              .fg-white {
                color: var(--white);
              }

              .bg-white {
                background-color: var(--white);
              }

              .border-white {
                border: 1px solid var(--white);
              }

              .border-white {
                border-color: var(--white);
              }

              .shadow-white {
                box-shadow: .5em .5em .25em var(--white);
              }

              .fg-black_dull {
                color: var(--black_dull);
              }

              .bg-black_dull {
                background-color: var(--black_dull);
              }

              .border-black_dull {
                border: 1px solid var(--black_dull);
              }

              .border-black_dull {
                border-color: var(--black_dull);
              }

              .shadow-black_dull {
                box-shadow: .5em .5em .25em var(--black_dull);
              }

              .fg-black_bright {
                color: var(--black_bright);
              }

              .bg-black_bright {
                background-color: var(--black_bright);
              }

              .border-black_bright {
                border: 1px solid var(--black_bright);
              }

              .border-black_bright {
                border-color: var(--black_bright);
              }

              .shadow-black_bright {
                box-shadow: .5em .5em .25em var(--black_bright);
              }

              .fg-red_dull {
                color: var(--red_dull);
              }

              .bg-red_dull {
                background-color: var(--red_dull);
              }

              .border-red_dull {
                border: 1px solid var(--red_dull);
              }

              .border-red_dull {
                border-color: var(--red_dull);
              }

              .shadow-red_dull {
                box-shadow: .5em .5em .25em var(--red_dull);
              }

              .fg-red_bright {
                color: var(--red_bright);
              }

              .bg-red_bright {
                background-color: var(--red_bright);
              }

              .border-red_bright {
                border: 1px solid var(--red_bright);
              }

              .border-red_bright {
                border-color: var(--red_bright);
              }

              .shadow-red_bright {
                box-shadow: .5em .5em .25em var(--red_bright);
              }

              .fg-green_dull {
                color: var(--green_dull);
              }

              .bg-green_dull {
                background-color: var(--green_dull);
              }

              .border-green_dull {
                border: 1px solid var(--green_dull);
              }

              .border-green_dull {
                border-color: var(--green_dull);
              }

              .shadow-green_dull {
                box-shadow: .5em .5em .25em var(--green_dull);
              }

              .fg-green_bright {
                color: var(--green_bright);
              }

              .bg-green_bright {
                background-color: var(--green_bright);
              }

              .border-green_bright {
                border: 1px solid var(--green_bright);
              }

              .border-green_bright {
                border-color: var(--green_bright);
              }

              .shadow-green_bright {
                box-shadow: .5em .5em .25em var(--green_bright);
              }

              .fg-yellow_dull {
                color: var(--yellow_dull);
              }

              .bg-yellow_dull {
                background-color: var(--yellow_dull);
              }

              .border-yellow_dull {
                border: 1px solid var(--yellow_dull);
              }

              .border-yellow_dull {
                border-color: var(--yellow_dull);
              }

              .shadow-yellow_dull {
                box-shadow: .5em .5em .25em var(--yellow_dull);
              }

              .fg-yellow_bright {
                color: var(--yellow_bright);
              }

              .bg-yellow_bright {
                background-color: var(--yellow_bright);
              }

              .border-yellow_bright {
                border: 1px solid var(--yellow_bright);
              }

              .border-yellow_bright {
                border-color: var(--yellow_bright);
              }

              .shadow-yellow_bright {
                box-shadow: .5em .5em .25em var(--yellow_bright);
              }

              .fg-blue_dull {
                color: var(--blue_dull);
              }

              .bg-blue_dull {
                background-color: var(--blue_dull);
              }

              .border-blue_dull {
                border: 1px solid var(--blue_dull);
              }

              .border-blue_dull {
                border-color: var(--blue_dull);
              }

              .shadow-blue_dull {
                box-shadow: .5em .5em .25em var(--blue_dull);
              }

              .fg-blue_bright {
                color: var(--blue_bright);
              }

              .bg-blue_bright {
                background-color: var(--blue_bright);
              }

              .border-blue_bright {
                border: 1px solid var(--blue_bright);
              }

              .border-blue_bright {
                border-color: var(--blue_bright);
              }

              .shadow-blue_bright {
                box-shadow: .5em .5em .25em var(--blue_bright);
              }

              .fg-magenta_dull {
                color: var(--magenta_dull);
              }

              .bg-magenta_dull {
                background-color: var(--magenta_dull);
              }

              .border-magenta_dull {
                border: 1px solid var(--magenta_dull);
              }

              .border-magenta_dull {
                border-color: var(--magenta_dull);
              }

              .shadow-magenta_dull {
                box-shadow: .5em .5em .25em var(--magenta_dull);
              }

              .fg-magenta_bright {
                color: var(--magenta_bright);
              }

              .bg-magenta_bright {
                background-color: var(--magenta_bright);
              }

              .border-magenta_bright {
                border: 1px solid var(--magenta_bright);
              }

              .border-magenta_bright {
                border-color: var(--magenta_bright);
              }

              .shadow-magenta_bright {
                box-shadow: .5em .5em .25em var(--magenta_bright);
              }

              .fg-cyan_dull {
                color: var(--cyan_dull);
              }

              .bg-cyan_dull {
                background-color: var(--cyan_dull);
              }

              .border-cyan_dull {
                border: 1px solid var(--cyan_dull);
              }

              .border-cyan_dull {
                border-color: var(--cyan_dull);
              }

              .shadow-cyan_dull {
                box-shadow: .5em .5em .25em var(--cyan_dull);
              }

              .fg-cyan_bright {
                color: var(--cyan_bright);
              }

              .bg-cyan_bright {
                background-color: var(--cyan_bright);
              }

              .border-cyan_bright {
                border: 1px solid var(--cyan_bright);
              }

              .border-cyan_bright {
                border-color: var(--cyan_bright);
              }

              .shadow-cyan_bright {
                box-shadow: .5em .5em .25em var(--cyan_bright);
              }

              .fg-white_dull {
                color: var(--white_dull);
              }

              .bg-white_dull {
                background-color: var(--white_dull);
              }

              .border-white_dull {
                border: 1px solid var(--white_dull);
              }

              .border-white_dull {
                border-color: var(--white_dull);
              }

              .shadow-white_dull {
                box-shadow: .5em .5em .25em var(--white_dull);
              }

              .fg-white_bright {
                color: var(--white_bright);
              }

              .bg-white_bright {
                background-color: var(--white_bright);
              }

              .border-white_bright {
                border: 1px solid var(--white_bright);
              }

              .border-white_bright {
                border-color: var(--white_bright);
              }

              .shadow-white_bright {
                box-shadow: .5em .5em .25em var(--white_bright);
              }
            </style>
          </head>
          <body>
            <table>
              <thead>
                <tr>
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
            </table>
          </body
        </html>
      '';
    };
  };
}
