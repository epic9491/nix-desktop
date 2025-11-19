{ config, lib, pkgs, inputs, ... }:

{
  ### Sound/Bluetooth block ###
   services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
   };
   hardware.bluetooth = {
     enable = true;
     powerOnBoot = true;
     settings = {
       General = {
         Experimental = true;
         FastConnectable = false;
       };
       Policy = {
         AutoEnable = true;
       };
     };
   };
   services.blueman.enable = true;
   programs.nm-applet.enable = true;
   environment.systemPackages = with pkgs; [
     xfce.xfce4-whiskermenu-plugin
     xfce.xfce4-pulseaudio-plugin
     xfce.xfce4-cpugraph-plugin
     xfce.xfce4-battery-plugin
     zuki-themes
     lightdm-gtk-greeter
 ];
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = { # <-- This block gives the greeter dark theme and use .face
    enable = true;
    greeters.gtk = {
      enable = true;
      theme = {
        name = "Graphite-Dark";
        package = pkgs.graphite-gtk-theme;
      };
      extraConfig = ''
        default-user-image=/usr/share/pixmaps/gumbo-face.png
      '';
    };
  };
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.defaultSession = "xfce";
  services.picom = { # Causes issues if xfce compositor is enabled
    enable = true;
    fade = true;
    inactiveOpacity = 0.7;
    shadow = true;
    fadeDelta = 4;
    backend = "glx";
    vSync = true;
 };
}
