{ nixpkgs, nix-gaming, ... }:

_: prev: {
  steam = prev.steam.override {
    extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${nix-gaming.packages.${prev.system}.proton-ge}'";
  };
}
