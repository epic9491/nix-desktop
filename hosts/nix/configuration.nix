{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./xfce/xfce.nix
      inputs.home-manager.nixosModules.default 
   ];
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   # Use systemd boot, best for UEFI
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   swapDevices = [
     {
       device = "/dev/disk/by-uuid/b5e6c2a1-f08f-4d67-9817-fba0e7298b65";
     }
   ];
   # Use latest kernel
   boot.kernelPackages = pkgs.linuxPackages_latest;
   networking.hostName = "nix";
   networking.networkmanager.enable = true;
   nixpkgs.config.allowUnfree = true;
   # Time Zone
   time.timeZone = "America/Chicago";
   # Internationalization properties
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
   };
   # Enable touchpad support
   services.libinput.enable = true;
   # Define user account
   users.users.gumbo = {
     isNormalUser = true;
     extraGroups = [ 
    "wheel"
    "networkmanager"
    "sound"
    "video"
    ];
  };
   home-manager = {
     extraSpecialArgs = { inherit inputs; };
     users = {
       "gumbo" = import ./home.nix;
     };
   };
   home-manager.backupFileExtension = "backup";
   # --- Firefox --- #
   programs.firefox.enable = true;
   # List packages installed in system profile.
   environment.systemPackages = with pkgs; [
     vim
     wget
     git
     htop
     curl
     eza
     ghostty
     fastfetch
     bitwarden-desktop
     spotify
     yubioath-flutter
     starship
     vscode
     lazyssh
     brave
 ];
   ### Firewall ###
   # networking.firewall.allowedTCPPorts = [ ... ];
   # networking.firewall.allowedUDPPorts = [ ... ];
   # networking.firewall.enable = false;

   # --- services --- #
   # services.qemuGuest.enable = true; # <-- only used for VMs, enables clipboard and ACPI shutdown signals 
   # services.spice-vdagentd.enable = true; # <-- same here lol

   services.tailscale.enable = true;
   services.openssh.enable = true;
   services.pcscd.enable = true; # <-- yubikey dependecy
 
   # --- FLATPAKS --- #
   services.flatpak.enable = true;
   systemd.services.flatpak-repo = {
     wantedBy = [ "multi-user.target" ];
     path = [ pkgs.flatpak ];
     script = ''
       flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
     '';
   };
   xdg.portal.enable = true; # <-- required for flatpaks
   xdg.portal.extraPortals = [ # <-- required for flatpak apps to run
     pkgs.xdg-desktop-portal-gtk
     pkgs.xdg-desktop-portal-xapp
    ];
   ### shell aliases ###
   environment.shellAliases = {
     update = "sudo nixos-rebuild switch --upgrade --flake /home/gumbo/nixos#nix";
     list_sys_gens = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
     rebuild_switch = "sudo nixos-rebuild switch --flake /home/gumbo/nixos#nix";
   };
   ########## DO NOT TOUCH ##########
   system.stateVersion = "25.05"; # Did you read the comment?
 }
