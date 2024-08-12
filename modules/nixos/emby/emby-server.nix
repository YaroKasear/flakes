{ lib, pkgs, dataDir, ... }:
with lib;
with pkgs;

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "4.8.8.0";

  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby.Releases/releases/download/${version}/embyserver-netcore_${version}.zip";
    sha256 = "aglGe0s77UDLWbnJb1VxzhJcY0eq7mN7RFXwOXVEFBU=";
  };

  buildInputs = [
    unzip
    makeWrapper
  ];

  propagatedBuildInputs = [
    dotnet-sdk
    sqlite
  ];

  preferLocalBuild = true;

  buildPhase = ''
    rm -rf ./{electron,runtimes/{osx,tizen*,win*}}
  '';

  installPhase = ''
    install -dm 755 $out/usr/lib
    cp -dr --no-preserve=ownership . $out/usr/lib/emby-server
    makeWrapper "${dotnet-sdk}/bin/dotnet" $out/bin/emby \
    --prefix LD_LIBRARY_PATH : "${strings.makeLibraryPath [
      sqlite
    ]}" \
    --add-flags "$out/usr/lib/emby-server/EmbyServer.dll -ffmpeg ${ffmpeg}/bin/ffmpeg -ffprobe ${ffmpeg}/bin/ffprobe -programdata ${dataDir}"
  '';
}