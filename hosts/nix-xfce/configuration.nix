{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/common.nix
    ../../profiles/xfce/system.nix
  ];

  networking.hostName = "nix-xfce";
}
