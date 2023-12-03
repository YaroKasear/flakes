{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sonic3air";
  version = "22.09.10.0-stable";

  src = fetchurl {
    url="https://github.com/Eukaryot/sonic3air/archive/refs/tags/v22.09.10.0-stable.tar.gz";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  buildInputs = [
    cmake
    libGL
    libGLU
    alsa-lib
    libpulseaudio
    libXcomposite
    libXxf86vm
    curl
  ]
}
