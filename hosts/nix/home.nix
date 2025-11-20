{ config, pkgs, lib, ... }:

{
  home.username = "gumbo";
  home.homeDirectory = "/home/gumbo";
  home.stateVersion = "25.05";
  imports = [
    ./xfce/xfce-home.nix
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      hello = "echo hey";
      ls = "eza";
      battery-health = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
    };
    initExtra = ''
      export EZA_CONFIG_DIR="$HOME/.config/eza"
      export EZA_ICONS_AUTO=1
    '';
  };
  home.packages = with pkgs; [
    # add per-user packages here
  ];
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  ### ~/.config symlinks ###
  xdg.configFile = {
    "starship.toml".source = ./config/starship/starship.main.toml;
    "ghostty/config".source = ./config/ghostty.config;
    "eza/theme.yml".source = ./config/eza.yml;
  };
  home.file = {
    # example:
    # ".screenrc".source = ./dotfiles/screenrc;
  };
  home.sessionVariables = {
    # EDITOR = "nvim";
  };
  programs.home-manager.enable = true;
}
