{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  inherit (lib.united) mkOpt enabled;

  cfg = config.united.style;
in {
  options.united.style = {
    enable = mkEnableOption "Style module!";
    fonts = {
      emoji = mkOpt types.str "Noto Color Emoji" "Emoji font!";
      interface = mkOpt types.str "FiraCode Nerd Font" "User interface font!";
      terminal = mkOpt types.str "FiraCode Nerd Font Mono" "Terminal font!";
    };
    wallpaper = mkOpt types.path ../wallpaper/files/maze.png "Wallpaper!";
    windows = {
      border-size = mkOpt types.number 2 "Border size of window in pixels.";
      radius = mkOpt types.number 10 "Radius of rounded window edges in pixels.";
    };
    effects = {
      shadow = {
        spread = mkOpt types.number 5 "Spread of the shadow in pixels.";
        offsetX = mkOpt types.number 5 "Horizontal offset of drop shadow in pixels.";
        offsetY = mkOpt types.number 5 "Vertical offset of drop shadow in pixels.";
        blur = mkOpt types.number 5 "Blur of drop shadow in pixels.";
        active-color = mkOpt types.str "${cfg.colors.black}" "Color of the drop shadow in RGB hex notation.";
        inactive-color = mkOpt types.str "${cfg.colors.black}" "Color of the drop shadow in RGB hex notation.";
      };
    };
    colors = with inputs.nix-rice.lib.color; {
      black = mkOpt types.str "${cfg.colors.black_dull}" "My black color!";
      red = mkOpt types.str "${cfg.colors.red_dull}" "My red color!";
      green = mkOpt types.str "${cfg.colors.green_dull}" "My green color!";
      yellow = mkOpt types.str "${cfg.colors.yellow_dull}" "My yellow color!";
      blue = mkOpt types.str "${cfg.colors.blue_dull}" "My blue color!";
      magenta = mkOpt types.str "${cfg.colors.magenta_dull}" "My magenta color!";
      cyan = mkOpt types.str "${cfg.colors.cyan_dull}" "My cyan color!";
      white = mkOpt types.str "${cfg.colors.white_dull}" "My white color!";

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

      color0 = mkOpt types.str  "${toRgbHex {r = 0;   g = 0;   b = 0;   a = 255;}}" "Color 0";
      color1 = mkOpt types.str  "${toRgbHex {r = 170; g = 0;   b = 0;   a = 255;}}" "Color 1";
      color2 = mkOpt types.str  "${toRgbHex {r = 0;   g = 170; b = 0;   a = 255;}}" "Color 2";
      color3 = mkOpt types.str  "${toRgbHex {r = 170; g = 85;  b = 0;   a = 255;}}" "Color 3";
      color4 = mkOpt types.str  "${toRgbHex {r = 0;   g = 0;   b = 170; a = 255;}}" "Color 4";
      color5 = mkOpt types.str  "${toRgbHex {r = 170; g = 0;   b = 170; a = 255;}}" "Color 5";
      color6 = mkOpt types.str  "${toRgbHex {r = 0;   g = 170; b = 170; a = 255;}}" "Color 6";
      color7 = mkOpt types.str  "${toRgbHex {r = 170; g = 170; b = 170; a = 255;}}" "Color 7";
      color8 = mkOpt types.str  "${toRgbHex {r = 85;  g = 85;  b = 85;  a = 255;}}" "Color 8";
      color9 = mkOpt types.str  "${toRgbHex {r = 255; g = 85;  b = 85;  a = 255;}}" "Color 9";
      color10 = mkOpt types.str "${toRgbHex {r = 85;  g = 255; b = 85;  a = 255;}}" "Color 10";
      color11 = mkOpt types.str "${toRgbHex {r = 255; g = 255; b = 85;  a = 255;}}" "Color 11";
      color12 = mkOpt types.str "${toRgbHex {r = 85;  g = 85;  b = 255; a = 255;}}" "Color 12";
      color13 = mkOpt types.str "${toRgbHex {r = 255; g = 85;  b = 255; a = 255;}}" "Color 13";
      color14 = mkOpt types.str "${toRgbHex {r = 85;  g = 255; b = 255; a = 255;}}" "Color 14";
      color15 = mkOpt types.str "${toRgbHex {r = 255; g = 255; b = 255; a = 255;}}" "Color 15";
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

                .desktop {
                  font-family: FiraCode Nerd Font, sans-serif;
                  background-color: var(--background);
                  background-image: url("${cfg.wallpaper}");
                }

                .window {
                  outline: 1px solid var(--black);
                  border-top-right-radius: ${toString cfg.windows.radius}px;
                  border-top-left-radius: ${toString cfg.windows.radius}px;
                }

                .titlebar {
                  border-top-right-radius: ${toString cfg.windows.radius}px;
                  border-top-left-radius: ${toString cfg.windows.radius}px;
                  border-bottom: 1px solid var(--black);
                  padding-left: .5em;
                  padding-right: .5em;
                }

                .window-body {
                  background-color: var(--background);
                  width: 100%;
                  height: calc(100% - 1.55em);
                }

                .window.active {
                  border: ${toString cfg.windows.border-size}px solid var(--active_border_color);
                  box-shadow: ${toString cfg.effects.shadow.offsetX}px ${toString cfg.effects.shadow.offsetX}px ${toString cfg.effects.shadow.blur}px ${toString cfg.effects.shadow.spread}px ${cfg.effects.shadow.active-color};
                }

                .titlebar.active {
                  background-color: var(--active_tab_background);
                  color: var(--active_tab_foreground);
                }

                .window.inactive {
                  border: ${toString cfg.windows.border-size}px solid var(--inactive_border_color);
                  box-shadow: ${toString cfg.effects.shadow.offsetX}px ${toString cfg.effects.shadow.offsetX}px ${toString cfg.effects.shadow.blur}px ${toString cfg.effects.shadow.spread}px ${cfg.effects.shadow.inactive-color};
                }

                .titlebar.inactive {
                  background-color: var(--inactive_tab_background);
                  color: var(--inactive_tab_foreground);
                }
              </style>
            </head>
            <body>
              <div class="container">
                <div class="container border w-100 h-75 mt-5 desktop">
                  <div class="row h-100">
                    <div class="col my-2">
                      <div class="window active h-100">
                        <div class="titlebar active">Active Window</div>
                        <div class="window-body"></div>
                      </div>
                    </div>
                    <div class="col my-2">
                      <div class="window inactive h-100">
                        <div class="titlebar inactive">Inactive Window</div>
                        <div class="window-body"></div>
                      </div>
                    </div>
                  </div>
                </div>
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
                    <tr><th>Black</th><td style="background-color: var(--black);"></td><td style="background-color: var(--black_dull);"></td><td style="background-color: var(--black_bright);"></td></tr>
                    <tr><th>Red</th><td style="background-color: var(--red);"></td><td style="background-color: var(--red_dull);"></td><td style="background-color: var(--red_bright);"></td></tr>
                    <tr><th>Green</th><td style="background-color: var(--green);"></td><td style="background-color: var(--green_dull);"></td><td style="background-color: var(--green_bright);"></td></tr>
                    <tr><th>Yellow</th><td style="background-color: var(--yellow);"></td><td style="background-color: var(--yellow_dull);"></td><td style="background-color: var(--yellow_bright);"></td></tr>
                    <tr><th>Blue</th><td style="background-color: var(--blue);"></td><td style="background-color: var(--blue_dull);"></td><td style="background-color: var(--blue_bright);"></td></tr>
                    <tr><th>Magenta</th><td style="background-color: var(--magenta);"></td><td style="background-color: var(--magenta_dull);"></td><td style="background-color: var(--magenta_bright);"></td></tr>
                    <tr><th>Cyan</th><td style="background-color: var(--cyan);"></td><td style="background-color: var(--cyan_dull);"></td><td style="background-color: var(--cyan_bright);"></td></tr>
                    <tr><th>White</th><td style="background-color: var(--white);"></td><td style="background-color: var(--white_dull);"></td><td style="background-color: var(--white_bright);"></td></tr>
                    <tr><th>Foreground Color</th><td style="background-color: var(--foreground);"></td><th>Background Color</th><td style="background-color: var(--background);"></td></tr>
                    <tr><th>Selection Foreground</th><td style="background-color: var(--selection_foreground);"></td><th>Selection Background</th><td style="background-color: var(--selection_background);"></td></tr>
                    <tr><th>Cursor Color</th><td colspan="3" style="background-color: var(--cursor);"></td></tr>
                    <tr><th>Cursor Text Color</th><td colspan="3" style="background-color: var(--cursor_text_color);"></td></tr>
                    <tr><th>Url Color</th><td colspan="3" style="background-color: var(--url_color);"></td></tr>
                    <tr><th>Visual Bell Color</th><td colspan="3" style="background-color: var(--visual_bell_color);"></td></tr>
                    <tr><th>Active Border Color</th><td colspan="3" style="background-color: var(--active_border_color);"></td></tr>
                    <tr><th>Inactive Border Color</th><td colspan="3" style="background-color: var(--inactive_border_color);"></td></tr>
                    <tr><th>Bell Border Color</th><td colspan="3" style="background-color: var(--bell_border_color);"></td></tr>
                    <tr><th>Active Tab Foreground</th><td colspan="3" style="background-color: var(--active_tab_foreground);"></td></tr>
                    <tr><th>Active Tab Background</th><td colspan="3" style="background-color: var(--active_tab_background);"></td></tr>
                    <tr><th>Inactive Tab Foreground</th><td colspan="3" style="background-color: var(--inactive_tab_foreground);"></td></tr>
                    <tr><th>Inactive Tab Background</th><td colspan="3" style="background-color: var(--inactive_tab_background);"></td></tr>
                    <tr><th>Tab Bar Background</th><td colspan="3" style="background-color: var(--tab_bar_background);"></td></tr>
                    <tr><th>Tab Bar Margin Color</th><td colspan="3" style="background-color: var(--tab_bar_margin_color);"></td></tr>
                    <tr><th>Mark 1 Background</th><td style="background-color: var(--mark1_background);"></td><th>Mark 1 Foreground</th><td style="background-color: var(--mark1_foreground);"></td></tr>
                    <tr><th>Mark 2 Background</th><td style="background-color: var(--mark2_background);"></td><th>Mark 2 Foreground</th><td style="background-color: var(--mark2_foreground);"></td></tr>
                    <tr><th>Mark 3 Background</th><td style="background-color: var(--mark3_background);"></td><th>Mark 3 Foreground</th><td style="background-color: var(--mark3_foreground);"></td></tr>
                    <tr><th>color0</th><td style="background-color: var(--color0);"></td><th>color8</th><td style="background-color: var(--color8);"></td></tr>
                    <tr><th>color1</th><td style="background-color: var(--color1);"></td><th>color9</th><td style="background-color: var(--color9);"></td></tr>
                    <tr><th>color2</th><td style="background-color: var(--color2);"></td><th>color10</th><td style="background-color: var(--color10);"></td></tr>
                    <tr><th>color3</th><td style="background-color: var(--color3);"></td><th>color11</th><td style="background-color: var(--color11);"></td></tr>
                    <tr><th>color4</th><td style="background-color: var(--color4);"></td><th>color12</th><td style="background-color: var(--color12);"></td></tr>
                    <tr><th>color5</th><td style="background-color: var(--color5);"></td><th>color13</th><td style="background-color: var(--color13);"></td></tr>
                    <tr><th>color6</th><td style="background-color: var(--color6);"></td><th>color14</th><td style="background-color: var(--color14);"></td></tr>
                    <tr><th>color7</th><td style="background-color: var(--color7);"></td><th>color15</th><td style="background-color: var(--color15);"></td></tr>
                  </tbody>
                </table>
              </div>

              <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
              <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
            </body>
          </html>
        '';
      };
    };
  };
}
