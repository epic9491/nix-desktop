{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./xfce/xfce.nix
    inputs.home-manager.nixosModules.default
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Use systemd boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
  nixpkgs.config.allowUnfree = true;
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/b5e6c2a1-f08f-4d67-9817-fba0e7298b65";
    }
  ];
  networking.hostName = "nix";
  networking.networkmanager.enable = true;
  # time zone
  time.timeZone = "America/Chicago";
  # internationalization properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  # user account
  users.users.gumbo = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "sound"
      "video"
      "libvirtd"
    ];
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gumbo" = import ./home.nix;
    };
  };
  home-manager.backupFileExtension = "backup";
  # firefox
  programs.firefox.enable = true;
  # list packages installed in system profile.
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
    nixfmt-rfc-style
  ];

  # firewall
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  services = {
    tailscale.enable = true;
    openssh.enable = true;
    pcscd.enable = true; # <-- yubikey dependecy
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    flatpak.enable = true;
    libinput.enable = true;
  };
  # virtualization
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  # flatpaks
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  xdg.portal.enable = true; # <-- required for flatpaks
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
  # shell aliases
  environment.shellAliases = {
    update = "sudo nixos-rebuild switch --upgrade --flake /home/gumbo/nixos#nix";
    list_sys_gens = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
    rebuild_switch = "sudo nixos-rebuild switch --flake /home/gumbo/nixos#nix";
  };
  ########## DO NOT TOUCH ##########
  system.stateVersion = "25.05";
}
