{ lib, inputs, pkgs, stdenv, ... }:
with pkgs;

pkgs.mkShell {
  packages = [
    (python3.withPackages(ps: with ps; [
      united.python-fabric
    ]))
  ];
}