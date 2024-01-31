{ nixpkgs, nix-gaming, ... }:

_: prev: {
  mpvpaper = prev.mpvpaper.overrideAttrs (old: {
    src = prev.fetchFromGithub {
      owner = "GhostNaN";
      repo = pname;
      rev = "65700a3ecc9ecd8ca501e18a807ee18845f9441";
      sha256 = "";
    };
  });
}
