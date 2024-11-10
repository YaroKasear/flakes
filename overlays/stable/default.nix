{ channels, inputs, ... }:

final: _prev: {
  stable = import inputs.nixpkgs-stable {
    system = final.system;
    config.allowUnfree = true;
  };
}
