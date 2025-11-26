{
  description = "The whole kit n kaboodle";

  inputs = {
    # Workstations - Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Servers - Stable
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Assigns reusable variables to stable/unstable
      libU = nixpkgs-unstable.lib;
      libS = nixpkgs-stable.lib;

      # Workstation builder
      mkWorkstation =
        { hostFile, hmImports }:
        libU.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            hostFile

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs; };

                # Workstation user
                users.gumbo = {
                  imports = hmImports;
                };
              };
            }
          ];
        };

      # Server builder
      mkServer =
        hostFile:
        libS.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            hostFile
          ];
        };
    in
    {
      nixosConfigurations = {

        # Legacy
        nix-hypr = mkWorkstation {
          hostFile = ./hosts/legacy/nix-hypr/configuration.nix;
          hmImports = [ ./hosts/legacy/nix-hypr/home.nix ];
        };

        nix-xfce = mkWorkstation {
          hostFile = ./hosts/legacy/nix-xfce/configuration.nix;
          hmImports = [ ./hosts/legacy/nix-xfce/home.nix ];
        };

        # Workstations
        erebos-hypr = mkWorkstation {
          hostFile = ./hosts/erebos/hypr.nix;
          hmImports = [
            ./home/common.nix
            ./home/hypr.nix
          ];
        };

        erebos-xfce = mkWorkstation {
          hostFile = ./hosts/erebos/xfce.nix;
          hmImports = [
            ./home/common.nix
            ./home/xfce.nix
          ];
        };

        prometheus-hypr = mkWorkstation {
          hostFile = ./hosts/prometheus/hypr.nix;
          hmImports = [
            ./home/common.nix
            ./home/hypr.nix
          ];
        };

        prometheus-xfce = mkWorkstation {
          hostFile = ./hosts/prometheus/xfce.nix;
          hmImports = [
            ./home/common.nix
            ./home/xfce.nix
          ];
        };

        # Servers
        gaia = mkServer ./hosts/servers/gaia.nix;
        dns = mkServer ./hosts/servers/dns.nix;
        manga = mkServer ./hosts/servers/manga.nix;
        uptime = mkServer ./hosts/servers/uptime.nix;
        btc = mkServer ./hosts/servers/btc.nix;
        v-hetz-2 = mkServer ./hosts/servers/v-hetz-2.nix;
        v-hetz-pango = mkServer ./hosts/servers/v-hetz-pango.nix;
      };
    };
}
