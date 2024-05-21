{ lib, inputs, pkgs, stdenv, ... }:
with pkgs;

pkgs.mkShell {
  packages = [
    gobject-introspection
    gtk3
    gtk-layer-shell
    (python3.withPackages(ps: with ps; [
      pygobject3
      united.python-fabric
    ]))
  ];
}