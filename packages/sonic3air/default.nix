{ lib, inputs, namespace, pkgs, stdenv, fetchurl, ... }:

stdenv.mkDerivation rec {
    pname = "sonic3air";
    version = "24.02.02.0";

    src = fetchurl {
      url = "https://github.com/Eukaryot/sonic3air/archive/refs/tags/v${version}-stable.tar.gz";
      sha256 = "sha256-kgwOUim1Hy5C53d5ery4vdPzrOmXKnae1ad3E0q9pFM=";
    };

    buildInputs = with pkgs; [
      alsa-lib
      cmake
      curl
      libGL
      libGLU
      libpulseaudio
      xorg.libX11.dev
      xorg.libXcomposite
      xorg.libXext
      xorg.libXxf86vm
    ];

    configurePhase = ''
      mkdir ./Oxygen/sonic3air/build/_cmake/build
      pushd ./Oxygen/sonic3air/build/_cmake/build
      cmake -DCMAKE_BUILD_TYPE=Release ..
    '';

    # buildPhase = ''
    #   cmake --build .
    # '';

    installPhase = ''
      popd
      mkdir -p $out/{bin,opt}
      cp -r Oxygen/sonic3air/{data,sonic3air_linux} $out/opt
      ln -s $out/opt/Oxygen/sonic3air/sonix3air_linux $out/bin/sonic3air_linux
    '';

}