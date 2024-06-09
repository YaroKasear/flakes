{ lib, inputs, namespace, pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
    pname = "sonic3air";
    version = "24.02.02.0";

    src = fetchurl {
      url = "https://github.com/Eukaryot/sonic3air/archive/refs/tags/v${version}-stable.tar.gz"
      sha256 = "";
    };
}