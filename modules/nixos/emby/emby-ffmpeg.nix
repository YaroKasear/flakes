{lib, pkgs, ...}:
with lib;
with pkgs;

mkDerivation rec {
  name = "emby-ffmpeg-${version}";
  version = "2023_06_25";
  stdenv = pkgs.clangStdenv;

  srcs = [
    (fetchurl {
      url = "https://mediabrowser.github.io/embytools/ffmpeg-${version}-u1.tar.gz";
      sha256 = "";
    })
    (fetchurl {
      url = "https://mediabrowser.github.io/embytools/ffdetect-${version}-x64.tar.xz";
      sha256 = "";
    })
    (fetchurl {
      url = "https://github.com/FFmpeg/FFmpeg/commit/effadce6c756247ea8bae32dc13bb3e6f464f0eb.patch";
      sha256 = "";
    })
    (fetchurl {
      url = "https://github.com/FFmpeg/FFmpeg/commit/03823ac0c6a38bd6ba972539e3203a592579792f.patch";
      sha256 = "";
    })
    (fetchurl {
      url = "https://github.com/FFmpeg/FFmpeg/commit/d2b46c1ef768bc31ba9180f6d469d5b8be677500.patch";
      sha256 = "";
    })
    (fetchurl {
      url = "https://github.com/FFmpeg/FFmpeg/commit/43b417d516b0fabbec1f02120d948f636b8a018e.patch";
      sha256 = "";
    })
    (fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/emby-ffmpeg/-/raw/main/06c2a2c425f22e7dba5cad909737a631cc676e3f.patch";
      sha256 = "";
    })
    (fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/emby-ffmpeg/-/raw/main/mbedtls-3.6.patch";
      sha256 = "";
    })
  ];

  buildInputs = [
    nasm
    nv-codec-headers
  ];

  propagatedBuildInputs = [

  ];
}