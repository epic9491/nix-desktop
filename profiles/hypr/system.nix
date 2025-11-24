{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "gumbo";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    foot
    waybar
    kitty
    hyprpaper
    ghostty
    screen
    rofi
    tokyonight-gtk-theme
    brightnessctl
    pamixer
    grim
    slurp
    wl-clipboard
    swayimg
    vlc
    nemo
    gvfs
  ];
}
