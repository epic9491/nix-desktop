{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./containers.nix
  ];

  # Hostname
  networking.hostName = "erebos";

  # Erebos-specific tweaks
}
