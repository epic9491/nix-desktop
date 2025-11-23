{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.git.enable = true;

  #programs.bash.shellAliases.hypr = "echo land";

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

  gtk = {
    enable = true;

    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };

    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Tokyonight-Dark";
      icon-theme = "Adwaita";
    };
  };
}
