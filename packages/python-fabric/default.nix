{ pkgs, ... }:
with pkgs.python3Packages;

buildPythonPackage {
  pname = "python-fabric";
  version = "git";
  pyproject = true;
  strictDeps = false;

  src = pkgs.fetchFromGitHub {
    owner = "Fabric-Development";
    repo = "fabric";
    rev = "67978f7";
    hash = "sha256-4sLlnR1gFzeDjrxvx76dwcSaM3Q5phL6LgwUP2VLCic=";
  };

  nativeBuildInputs = with pkgs; [
    gtk-layer-shell
  ];

  propagatedBuildInputs = with pkgs; [
    loguru
    python3Packages.click
    pycairo
    pygobject3
    setuptools
    tree
    wrapGAppsHook
  ];

  postInstall = ''
    mkdir -p $out/bin
    cp ${./files/config.py} $out/bin/config.py
    chmod +x $out/bin/config.py
  '';
}
