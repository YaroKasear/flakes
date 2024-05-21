{ lib, inputs, pkgs, stdenv, ... }:
with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "python-fabric";
  version = "git";
  pyproject = true;

  src = ./files/config.py;

  propagatedBuildInputs = with pkgs; [
    gobject-introspection
    gtk3
    gtk-layer-shell
    (python3.withPackages(ps: with ps; [
      pygobject3
      united.python-fabric
    ]))
    wrapGAppsHook
  ];
}
