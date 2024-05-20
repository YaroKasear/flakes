{ lib, inputs, pkgs, stdenv, buildPythonPackage, ... }:

buildPythonPackage rec {
  pname = "python-fabric";
  version = "git";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "Fabric-Development";
    name = "fabric";
    rev = "67978f7";
    hash = "";
  };
}
