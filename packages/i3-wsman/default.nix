{ lib, inputs, pkgs, stdenv, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "i3-wsman";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "i3-wsman";
    repo = pname;
    rev = "8a30ee3";
    sha256 = "5yssQNVi7RO1mhsaqIcL8Tw9Jpsnc1sNhsAAqE+GBis=";
  };

  cargoHash = "sha256-X6hheRJXO6by6aRbgmzUBBRF4C4zJs6/3Mu9dPOGrkA=";

  meta = with lib; {
    description = "Create, reorder, group, and focus workspaces easily in i3. Fully configurable with enhanced polybar modules.";
    homepage = "https://github.com/i3-wsman/i3-wsman";
    license = licenses.lgpl3;
  };

}
