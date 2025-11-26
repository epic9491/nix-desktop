{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../profiles/common.nix
    ../../profiles/hypr/system.nix
    ../../devices/laptop/prometheus/default.nix
  ];
}
