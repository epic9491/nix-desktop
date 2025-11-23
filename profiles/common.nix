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

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
    ];
    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Inter"
          "Noto Sans"
        ];
        serif = [ "Noto Serif" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };

    fontDir.enable = true;
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
    upower
    blueman
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

  services.syncthing = {
    enable = true;
    user = "gumbo";
    group = "users";
    dataDir = "/home/gumbo/sync";
    configDir = "/home/gumbo/.config/syncthing";
    overrideDevices = false;
    overrideFolders = false;
    openDefaultPorts = true;
    settings = {
      devices = {
        "manga" = {
          id = "I3J5UCJ-NZIOJCX-FIV6PUT-QSTITFA-4TI6PB7-MVR67TI-SW56QXD-6ARBAAE";
        };
        "erebos" = {
          id = "DBCLUXM-MWHS7OZ-AJIDHAY-GFGTMDW-5RBCU4P-M4RE3IF-YMDWWOB-DNCSQQT";
        };
      };
      folders = {
        "retro-bios" = {
          id = "p4epq-mmgmv";
          path = "/home/gumbo/sync/retro/BIOS";
          devices = [
            "manga"
            "erebos"
          ];
          type = "receiveonly";
        };
        "retro-roms" = {
          id = "74edp-unucu";
          path = "/home/gumbo/sync/retro/ROMs";
          devices = [
            "manga"
            "erebos"
          ];
          type = "receiveonly";
        };
        "retro-saves" = {
          id = "ymtp3-m4ngw";
          path = "/home/gumbo/sync/retro/Saves";
          devices = [
            "manga"
            "erebos"
          ];
          type = "sendreceive";
        };
      };
    };
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

  services.upower.enable = true;

  programs.dconf.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.shellAliases = {
    update_xfce = "sudo nixos-rebuild switch --upgrade --flake /home/gumbo/nixos#nix-xfce";
    update_hypr = "sudo nixos-rebuild switch --upgrade --flake /home/gumbo/nixos#nix-hypr";
    rebuild_xfce = "sudo nixos-rebuild switch --flake /home/gumbo/nixos#nix-xfce";
    rebuild_hypr = "sudo nixos-rebuild switch --flake /home/gumbo/nixos#nix-hypr";
    rebuild_boot_xfce = "sudo nixos-rebuild boot --flake /home/gumbo/nixos#nix-xfce";
    rebuild_boot_hypr = "sudo nixos-rebuild boot --flake /home/gumbo/nixos#nix-hypr";
    list_sys_gens = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
  };

  system.stateVersion = "25.05";
}
