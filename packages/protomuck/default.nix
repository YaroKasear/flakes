{ lib, inputs, pkgs, stdenv, ... }:

stdenv.mkDerivation {
    name = "ProtoMUCK";
    pname = "protomuck";

    src = fetchFromGitHub {
      owner = "protomuck";
      repo = pname;
      rev = "2c9204c31cdf9dea8cab2d45cc54fbbfd71f8f91";
      sha256 = "";
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
}