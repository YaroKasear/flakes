{ lib, stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  pname = "sonic3air";
  version = "22.09.10.0-stable";

  src = fetchurl {
    url="https://github.com/Eukaryot/sonic3air/archive/refs/tags/v22.09.10.0-stable.tar.gz";
    sha256 = "T4wZP7jbHqFM3LxJqgisLvayMBnjDB5xwfXhS/GZTTU=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];

  buildInputs = with pkgs; [
    libGL
    libGLU
    alsa-lib
    libpulseaudio
    curl
    xorg.libX11
    xorg.libX11.dev
    xorg.libXext
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release .." ];

  preConfigure = ''
    cd ./Oxygen/soncthrickles/build/_cmake
  '';
}
