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

    home.file =
      let style-css = ''
        * {
          background-color: ${cfg.colors.background};
          box-sizing: border-box;
          color: ${cfg.colors.foreground};
        }

        thead, tbody, tr, th, td {
          background-color: inherit;
          color: inherit;
        }

        .fg-black {
          color: ${cfg.colors.black};
        }

        .bg-black {
          background-color: ${cfg.colors.black};
        }

        .border-black {
          border-color: ${cfg.colors.black};
        }

        .fg-black-bright {
          color: ${cfg.colors.black_bright};
        }

        .bg-black-bright {
          background-color: ${cfg.colors.black_bright};
        }

        .border-black-bright {
          border-color: ${cfg.colors.black_bright};
        }

        .fg-black-dull {
          color: ${cfg.colors.black_dull};
        }

        .bg-black-dull {
          background-color: ${cfg.colors.black_dull};
        }

        .border-black-dull {
          border-color: ${cfg.colors.black_dull};
        }

        .fg-red {
          color: ${cfg.colors.red};
        }

        .bg-red {
          background-color: ${cfg.colors.red};
        }

        .border-red {
          border-color: ${cfg.colors.red};
        }

        .fg-red-bright {
          color: ${cfg.colors.red_bright};
        }

        .bg-red-bright {
          background-color: ${cfg.colors.red_bright};
        }

        .border-red-bright {
          border-color: ${cfg.colors.red_bright};
        }

        .fg-red-dull {
          color: ${cfg.colors.red_dull};
        }

        .bg-red-dull {
          background-color: ${cfg.colors.red_dull};
        }

        .border-red-dull {
          border-color: ${cfg.colors.red_dull};
        }

        .fg-green {
          color: ${cfg.colors.green};
        }

        .bg-green {
          background-color: ${cfg.colors.green};
        }

        .border-green {
          border-color: ${cfg.colors.green};
        }

        .fg-green-bright {
          color: ${cfg.colors.green_bright};
        }

        .bg-green-bright {
          background-color: ${cfg.colors.green_bright};
        }

        .border-green-bright {
          border-color: ${cfg.colors.green_bright};
        }

        .fg-green-dull {
          color: ${cfg.colors.green_dull};
        }

        .bg-green-dull {
          background-color: ${cfg.colors.green_dull};
        }

        .border-green-dull {
          border-color: ${cfg.colors.green_dull};
        }

        .fg-yellow {
          color: ${cfg.colors.yellow};
        }

        .bg-yellow {
          background-color: ${cfg.colors.yellow};
        }

        .border-yellow {
          border-color: ${cfg.colors.yellow};
        }

        .fg-yellow-bright {
          color: ${cfg.colors.yellow_bright};
        }

        .bg-yellow-bright {
          background-color: ${cfg.colors.yellow_bright};
        }

        .border-yellow-bright {
          border-color: ${cfg.colors.yellow_bright};
        }

        .fg-yellow-dull {
          color: ${cfg.colors.yellow_dull};
        }

        .bg-yellow-dull {
          background-color: ${cfg.colors.yellow_dull};
        }

        .border-yellow-dull {
          border-color: ${cfg.colors.yellow_dull};
        }

        .fg-blue {
          color: ${cfg.colors.blue};
        }

        .bg-blue {
          background-color: ${cfg.colors.blue};
        }

        .border-blue {
          border-color: ${cfg.colors.blue};
        }

        .fg-blue-bright {
          color: ${cfg.colors.blue_bright};
        }

        .bg-blue-bright {
          background-color: ${cfg.colors.blue_bright};
        }

        .border-blue-bright {
          border-color: ${cfg.colors.blue_bright};
        }

        .fg-blue-dull {
          color: ${cfg.colors.blue_dull};
        }

        .bg-blue-dull {
          background-color: ${cfg.colors.blue_dull};
        }

        .border-blue-dull {
          border-color: ${cfg.colors.blue_dull};
        }

        .fg-magenta {
          color: ${cfg.colors.magenta};
        }

        .bg-magenta {
          background-color: ${cfg.colors.magenta};
        }

        .border-magenta {
          border-color: ${cfg.colors.magenta};
        }

        .fg-magenta-bright {
          color: ${cfg.colors.magenta_bright};
        }

        .bg-magenta-bright {
          background-color: ${cfg.colors.magenta_bright};
        }

        .border-magenta-bright {
          border-color: ${cfg.colors.magenta_bright};
        }

        .fg-magenta-dull {
          color: ${cfg.colors.magenta_dull};
        }

        .bg-magenta-dull {
          background-color: ${cfg.colors.magenta_dull};
        }

        .border-magenta-dull {
          border-color: ${cfg.colors.magenta_dull};
        }

        .fg-cyan {
          color: ${cfg.colors.cyan};
        }

        .bg-cyan {
          background-color: ${cfg.colors.cyan};
        }

        .border-cyan {
          border-color: ${cfg.colors.cyan};
        }

        .fg-cyan-bright {
          color: ${cfg.colors.cyan_bright};
        }

        .bg-cyan-bright {
          background-color: ${cfg.colors.cyan_bright};
        }

        .border-cyan-bright {
          border-color: ${cfg.colors.cyan_bright};
        }

        .fg-cyan-dull {
          color: ${cfg.colors.cyan_dull};
        }

        .bg-cyan-dull {
          background-color: ${cfg.colors.cyan_dull};
        }

        .border-cyan-dull {
          border-color: ${cfg.colors.cyan_dull};
        }

        .fg-white {
          color: ${cfg.colors.white};
        }

        .bg-white {
          background-color: ${cfg.colors.white};
        }

        .border-white {
          border-color: ${cfg.colors.white};
        }

        .fg-white-bright {
          color: ${cfg.colors.white_bright};
        }

        .bg-white-bright {
          background-color: ${cfg.colors.white_bright};
        }

        .border-white-bright {
          border-color: ${cfg.colors.white_bright};
        }

        .fg-white-dull {
          color: ${cfg.colors.white_dull};
        }

        .bg-white-dull {
          background-color: ${cfg.colors.white_dull};
        }

        .border-white-dull {
          border-color: ${cfg.colors.white_dull};
        }

        .fg-color0 {
          color: ${cfg.colors.color0}
        }

        .bg-color0 {
          background-color: ${cfg.colors.color0}
        }

        .border-color0 {
          background-color: ${cfg.colors.color0}
        }

        .fg-color1 {
          color: ${cfg.colors.color1}
        }

        .bg-color1 {
          background-color: ${cfg.colors.color1}
        }

        .border-color1 {
          background-color: ${cfg.colors.color1}
        }

        .fg-color2 {
          color: ${cfg.colors.color2}
        }

        .bg-color2 {
          background-color: ${cfg.colors.color2}
        }

        .border-color2 {
          background-color: ${cfg.colors.color2}
        }

        .fg-color3 {
          color: ${cfg.colors.color3}
        }

        .bg-color3 {
          background-color: ${cfg.colors.color3}
        }

        .border-color3 {
          background-color: ${cfg.colors.color3}
        }

        .fg-color4 {
          color: ${cfg.colors.color4}
        }

        .bg-color4 {
          background-color: ${cfg.colors.color4}
        }

        .border-color4 {
          background-color: ${cfg.colors.color4}
        }

        .fg-color5 {
          color: ${cfg.colors.color5}
        }

        .bg-color5 {
          background-color: ${cfg.colors.color5}
        }

        .border-color5 {
          background-color: ${cfg.colors.color5}
        }

        .fg-color6 {
          color: ${cfg.colors.color6}
        }

        .bg-color6 {
          background-color: ${cfg.colors.color6}
        }

        .border-color6 {
          background-color: ${cfg.colors.color6}
        }

        .fg-color7 {
          color: ${cfg.colors.color7}
        }

        .bg-color7 {
          background-color: ${cfg.colors.color7}
        }

        .border-color7 {
          background-color: ${cfg.colors.color7}
        }

        .fg-color7 {
          color: ${cfg.colors.color7}
        }

        .bg-color7 {
          background-color: ${cfg.colors.color7}
        }

        .border-color7 {
          background-color: ${cfg.colors.color7}
        }

        .fg-color8 {
          color: ${cfg.colors.color8}
        }

        .bg-color8 {
          background-color: ${cfg.colors.color8}
        }

        .border-color8 {
          background-color: ${cfg.colors.color8}
        }

        .fg-color9 {
          color: ${cfg.colors.color9}
        }

        .bg-color9 {
          background-color: ${cfg.colors.color9}
        }

        .border-color9 {
          background-color: ${cfg.colors.color9}
        }

        .fg-color10 {
          color: ${cfg.colors.color10}
        }

        .bg-color10 {
          background-color: ${cfg.colors.color10}
        }

        .border-color10 {
          background-color: ${cfg.colors.color10}
        }

        .fg-color11 {
          color: ${cfg.colors.color11}
        }

        .bg-color11 {
          background-color: ${cfg.colors.color11}
        }

        .border-color11 {
          background-color: ${cfg.colors.color11}
        }

        .fg-color12 {
          color: ${cfg.colors.color12}
        }

        .bg-color12 {
          background-color: ${cfg.colors.color12}
        }

        .border-color12 {
          background-color: ${cfg.colors.color12}
        }

        .fg-color13 {
          color: ${cfg.colors.color13}
        }

        .bg-color13 {
          background-color: ${cfg.colors.color13}
        }

        .border-color13 {
          background-color: ${cfg.colors.color13}
        }

        .fg-color14 {
          color: ${cfg.colors.color14}
        }

        .bg-color14 {
          background-color: ${cfg.colors.color14}
        }

        .border-color14 {
          background-color: ${cfg.colors.color14}
        }

        .fg-color15 {
          color: ${cfg.colors.color15}
        }

        .bg-color15 {
          background-color: ${cfg.colors.color15}
        }

        .border-color15 {
          background-color: ${cfg.colors.color15}
        }

        .container {
          display: flex;
        }

        .border {
          border-width: 1px;
          border-style: solid;
        };

        .left {
          left: 0;
          margin-right: auto;
        }

        .center {
          left: 0;
          right: 0;
          margin: auto;
        }

        .right {
          right: 0;
          margin-left: auto;
        }

        .w-25 {
          width: 25%;
        }

        .w-50 {
          width: 50%;
        }

        .w-75 {
          width: 75%;
        }

        .w-100 {
          width: 100%;
        }

        .h-25 {
          height: 25%;
        }

        .h-50 {
          height: 50%;
        }

        .h-75 {
          height: 75%;
        }

        .h-100 {
          height: 100%;
        }
      '';
    in {
      "style/test.html".text = ''
        <html>
          <head>
            <style>
              ${style-css}

              table {
                table-layout: fixed;
              }
            </style>
          </head>
          <body class="bg-white fg-black">
            <table class="w-75 center bg-white fg-black">
              <thead>
                <tr>
                  <th></th>
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
                <tr>
                  <th>Black</th>
                  <td class="border bg-black"></td>
                  <td class="border bg-black-dull"></td>
                  <td class="border bg-black-bright"></td>
                </tr>
                <tr>
                  <th>Red</th>
                  <td class="border bg-red"></td>
                  <td class="border bg-red-dull"></td>
                  <td class="border bg-red-bright"></td>
                </tr>
                <tr>
                  <th>Green</th>
                  <td class="border bg-green"></td>
                  <td class="border bg-green-dull"></td>
                  <td class="border bg-green-bright"></td>
                </tr>
                <tr>
                  <th>Yellow</th>
                  <td class="border bg-yellow"></td>
                  <td class="border bg-yellow-dull"></td>
                  <td class="border bg-yellow-bright"></td>
                </tr>
                <tr>
                  <th>Blue</th>
                  <td class="border bg-blue"></td>
                  <td class="border bg-blue-dull"></td>
                  <td class="border bg-blue-bright"></td>
                </tr>
                <tr>
                  <th>Magenta</th>
                  <td class="border bg-magenta"></td>
                  <td class="border bg-magenta-dull"></td>
                  <td class="border bg-magenta-bright"></td>
                </tr>
                <tr>
                  <th>Cyan</th>
                  <td class="border bg-cyan"></td>
                  <td class="border bg-cyan-dull"></td>
                  <td class="border bg-cyan-bright"></td>
                </tr>
                <tr>
                  <th>White</th>
                  <td class="border bg-white"></td>
                  <td class="border bg-white-dull"></td>
                  <td class="border bg-white-bright"></td>
                </tr>
              </tbody>
            </table>
            <table class="w-75 center bg-white fg-black">
              <tr>
                <th>color0</th>
                <td class="border bg-color0"></td>
                <th>color8</th>
                <td class="border bg-color8"></td>
              </tr>
              <tr>
                <th>color1</th>
                <td class="border bg-color1"></td>
                <th>color9</th>
                <td class="border bg-color9"></td>
              </tr>
              <tr>
                <th>color2</th>
                <td class="border bg-color2"></td>
                <th>color10</th>
                <td class="border bg-color10"></td>
              </tr>
              <tr>
                <th>color3</th>
                <td class="border bg-color3"></td>
                <th>color11</th>
                <td class="border bg-color11"></td>
              </tr>
              <tr>
                <th>color4</th>
                <td class="border bg-color4"></td>
                <th>color12</th>
                <td class="border bg-color12"></td>
              </tr>
              <tr>
                <th>color5</th>
                <td class="border bg-color5"></td>
                <th>color13</th>
                <td class="border bg-color13"></td>
              </tr>
              <tr>
                <th>color6</th>
                <td class="border bg-color6"></td>
                <th>color14</th>
                <td class="border bg-color14"></td>
              </tr>
              <tr>
                <th>color7</th>
                <td class="border bg-color7"></td>
                <th>color15</th>
                <td class="border bg-color15"></td>
              </tr>
            </table>
            <div class="container border w-75 h-50 center bg-white-dull fg-black border-black">
            </div>
          </body>
        </html>
      '';
    };
  };
}
