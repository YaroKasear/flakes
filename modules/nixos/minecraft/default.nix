{ inputs, ... }: {
  nixpkgs.overlays = [ inputs.nix-mincraft.overlay ];
}
