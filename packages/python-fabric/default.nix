{ lib, inputs, pkgs, stdenv, ... }:
with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "python-fabric";
  version = "git";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "Fabric-Development";
    repo = "fabric";
    rev = "67978f7";
    hash = "sha256-4sLlnR1gFzeDjrxvx76dwcSaM3Q5phL6LgwUP2VLCic=";
  };

  propagatedBuildInputs = with pkgs; [
    setuptools
    python3Packages.click
    pycairo
    pygobject3
    loguru
  ];
}
