{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
      dxvk
      inputs.nix-gaming.packages.${pkgs.system}.vkd3d-proton
    ]
    # construct a list from the output attrset
    ++ (inputs.nix-gaming.lib.legendaryBuilder pkgs
      {
        games = {
          hitman-woa = {
            # find names with `legendary list`
            desktopName = "HITMAN: World of Assassination";

            # find out on lutris/winedb/protondb
            tricks = ["dxvk" "vkd3d" "fshack" "win10"];

            # google "<game name> logo"
            icon = builtins.fetchurl {
              # original url = "https://www.pngkey.com/png/full/16-160666_rocket-league-png.png";
              url = "https://image.api.playstation.com/vulcan/ap/rnd/202211/2311/nbu7afRlTDRCWOd6Z0UIKqGj.png";
              name = "hitman-woa.png";
              sha256 = "0a9ayr3vwsmljy7dpf8wgichsbj4i4wrmd8awv2hffab82fz4ykb";
            };

            # if you don't want winediscordipcbridge running for this game
            discordIntegration = true;
            # if you dont' want to launch the game using gamemode
            gamemodeIntegration = true;

            preCommands = ''
              echo "the game will start!"
            '';

            postCommands = ''
              echo "the game has stopped!"
            '';
          };
        };

        opts = {
          # same options as above can be provided here, and will be applied to all games
          # NOTE: game-specific options take precedence
          wine = inputs.nix-gaming.packages.${pkgs.system}.proton-ge;
        };
      });
}