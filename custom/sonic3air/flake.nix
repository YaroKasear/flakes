{
  outputs = {self, nixpkgs}: {
    overlay = final: prev: { sonic3air = prev.pkgs.callPackage ./derivation.nix { }; };

    packages.x86_64-linux.sonic3air = nixpkgs.legacyPackages.x86_64-linux.callPackage ./derivation.nix { };

    packages.x86_64-linux.default = self.packages.x86_64-linux.sonic3air;
  };
}
