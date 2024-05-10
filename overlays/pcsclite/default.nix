{ channels, ... }:

final: prev: {
  inherit (channels.nixpkgs) pcsclite;
}