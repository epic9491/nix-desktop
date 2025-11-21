{ config, pkgs, lib, ... }:

{
  home.username = "gumbo";
  home.homeDirectory = "/home/gumbo";
  home.stateVersion = "25.05";
  imports = [
    ./xfce/xfce-home.nix
  ];
  # enable bash and set aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      hello = "echo hey";
      ls = "eza";
      battery-health = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
      nix-forge2git = "cp -r ~/nixos/* ~/git-repos/nixos-github/";
    };
    # bash env variables, needs to be replaced declaritively
    initExtra = ''
      export EZA_CONFIG_DIR="$HOME/.config/eza"
      export EZA_ICONS_AUTO=1
    '';
  };
  home.packages = with pkgs; [
    # add per-user packages here
  ];
  # starship
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
   # btop
   programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      theme_background = true;
      truecolor = true;
    };
  };
  # ~/.config symlinks
  xdg.configFile = {
    "starship.toml".source = ./config/starship/starship.main.toml;
    "ghostty/config".source = ./config/ghostty.config;
    "eza/theme.yml".source = ./config/eza.yml;
  };
  # dconf for kvm/qemu
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  # home file
  home.file = {
    # example:
    # ".screenrc".source = ./dotfiles/screenrc;
  };
  # session variables
  home.sessionVariables = {
    # EDITOR = "nvim";
  };
  programs.home-manager.enable = true;
}
