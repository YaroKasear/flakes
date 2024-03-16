{ nixpkgs, nix-rice, ... }:

_: prev: {
  overlay = nix-rice.overlays.default;
}
