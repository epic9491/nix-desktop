{ config, pkgs, lib, ... }:

{
  programs.git.enable = true;

  programs.bash.shellAliases.hypr = "echo land";

  xdg.configFile."hypr" = {
    source = ../config/hypr;
    recursive = true;
  };

  xdg.configFile."waybar" = {
    source = ../config/waybar;
    recursive = true;
  };

  xdg.configFile."foot" = {
    source = ../config/foot;
    recursive = true;
  };
}
