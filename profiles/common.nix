{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

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

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    curl
    tree
    eza
    ghostty
    fastfetch
    starship
    bitwarden-desktop
    spotify
    yubioath-flutter
    vscode
    lazyssh
    brave
    signal-desktop
    protonmail-desktop
    nixfmt-rfc-style
    (retroarch.withCores (cores: with cores; [ mgba ]))
  ];

  services = {
    tailscale.enable = true;
    openssh.enable = true;
    pcscd.enable = true; # yubikey dep
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    flatpak.enable = true;
    libinput.enable = true;
  };

  # virtualization
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  # flatpak repo
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.shellAliases = {
    update_xfce = "sudo nixos-rebuild switch --upgrade --flake /home/gumbo/nixos#nix-xfce";
    update_hypr = "sudo nixos-rebuild switch --upgrade --flake /home/gumbo/nixos#nix-hypr";
    rebuild_xfce = "sudo nixos-rebuild switch --flake /home/gumbo/nixos#nix-xfce";
    rebuild_hypr = "sudo nixos-rebuild switch --flake /home/gumbo/nixos#nix-hypr";
    list_sys_gens = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
  };

  system.stateVersion = "25.05";
}
