{ config, pkgs, lib, ... }:

{
  pam.yubico.authorizedYubiKeys.ids = [
    "vvelbjguhtlv"
    "ccccccjfkvnh"
    "ccccccvvktff"
  ];
}