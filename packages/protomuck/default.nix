{ lib, inputs, pkgs, stdenv, ... }:

stdenv.mkDerivation {
    name = "protomuck";
    pname = "protomuck";

    src = pkgs.fetchFromGitHub {
      owner = "protomuck";
      repo = "protomuck";
      rev = "2c9204c31cdf9dea8cab2d45cc54fbbfd71f8f91";
      sha256 = "AjEzzvqIWGO1oIV7ljJfBxxAHjxHpE+5X7Ee3CxhrOk=";
    };

    buildInputs = with pkgs; [
      gcc
      flex
      bison
    ];

    buildPhase = ''
      cd src
      ./configure
      make
    '';

    installPhase = ''
      make install
      cd ../game/data
      cp minimal.proto proto.db
      cd ../..
      cp -r game $out
    '';

    meta = with lib; {
      description = "ProtoMUCK 2.0 MUCK Server";
      homepage = "https://github.com/protomuck/protomuck";
    };
}