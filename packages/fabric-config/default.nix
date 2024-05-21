{ lib, inputs, pkgs, stdenv, ... }:
with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "python-fabric";
  version = "git";
  pyproject = true;

  src = ./files/config.py;
  dontUnpack = true;

  propagatedBuildInputs = with pkgs; [
    gobject-introspection
    gtk3
    gtk-layer-shell
    (python3.withPackages(ps: with ps; [
      pygobject3
      united.python-fabric
    ]))
    setuptools
    wrapGAppsHook
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${./files/config.py} $out/bin/config.py
    chmod +x $out/bin/config.py
  '';
}
