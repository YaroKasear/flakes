{ lib, pkgs, dataDir, ... }:
with lib;
with pkgs;

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "4.8.8.0";

  # We are fetching a binary here, however, a source build is possible.
  # See -> https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=emby-server-git#n43
  # Though in my attempt it failed with this error repeatedly
  # The type 'Attribute' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'.
  # This may also need msbuild (instead of xbuild) which isn't in nixpkgs
  # See -> https://github.com/NixOS/nixpkgs/issues/29817
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