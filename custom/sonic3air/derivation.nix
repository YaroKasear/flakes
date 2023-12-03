{ lib, stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  pname = "sonic3air";
  version = "22.09.10.0-stable";

  src = fetchurl {
    url="https://github.com/Eukaryot/sonic3air/releases/download/v${version}/sonic3air_game.tar.gz";
    sha256 = "LAUtvU6COpcArHAPD8897KlD7/0GAExSNjhEtbBAljQ=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    basepath1="$PWD"
    basepath2="''${PWD// /\\ }"
    outpath=''${out}/share/applications/sonic3air.desktop
    mkdir -p ''${out}/share/applications/
    
    # Build .desktop launcher file
    cat <<EOM > "$outpath"
    [Desktop Entry]
    Name=Sonic 3 A.I.R.
    Type=Application
    Encoding=UTF-8
    Exec=$basepath2/sonic3air_linux
    Icon=$basepath1/data/icon.png
    Terminal=false
    EOM
    
    # Set executable flag
    chmod +x $outpath
  '';
}
