{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "prometheus";

  # Prometheus Tweaks
}
