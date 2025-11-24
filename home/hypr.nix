{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.git.enable = true;

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

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

}
