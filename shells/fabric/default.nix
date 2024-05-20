{ lib, inputs, pkgs, stdenv, ... }:
with pkgs;

pkgs.mkShell {
  packages = [
    (python3.withPackages(ps: with ps; [
      pygobject3
      united.python-fabric
    ]))
  ];
}