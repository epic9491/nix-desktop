{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../profiles/common.nix
    ../../profiles/xfce/system.nix
    ../../devices/desktop/erebos/default.nix
  ];
}
