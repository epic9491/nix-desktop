{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/common.nix
    ../../profiles/hypr/system.nix
  ];

  networking.hostName = "nix-hypr";

}
