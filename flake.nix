{
  description = "Reproducable NixOS and homemanager config for my local servers, cloud servers, desktops, and laptops,";

  nixConfig = {
    extra-substituters = [ "https://cachix.cachix.org" "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master"; # Very unstable! Useful for same-day hotfixes.

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    agenix.url = "github:ryantm/agenix";
    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    playdatesdk.url = "github:headblockhead/nix-playdatesdk";
    playdatemirror.url = "github:headblockhead/nix-playdatemirror";
    templ.url = "github:a-h/templ";
  };

  outputs =
    { self, nixpkgs, home-manager, agenix, deploy-rs, ... }@ inputs:
    let
      inherit (self) outputs;

      # System types we want to build our packages for, used to generate pkgs.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      sshkeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvr2FrC9i1bjoVzg+mdytOJ1P0KRtah/HeiMBuKD3DX cardno:23_836_181" # RED
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIvDaJmOSXV24B83sIfZqAUurs+cZ7582L4QDePuc3p7 cardno:17_032_332" # BACKUP 
      ];

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    rec {
      # Custom packages: accessible through 'nix build', 'nix shell', etc.
      packages = forAllSystems
        (system: import ./pkgs {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs system;
        });

      # Exported overlays. Includes custom packages and flake outputs.
      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        # Local servers
        gateway = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs agenix sshkeys; };
          modules = [
            ./systems/gateway/config.nix
            ./systems/gateway/hardware.nix
            agenix.nixosModules.default
          ];
        };

        rpi5-01 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs agenix sshkeys; };
          modules = [
            ./systems/rpi5-01/config.nix
            ./systems/wifi-config.nix # gitignored, see wifi-config-template.nix
            {
              raspberry-pi-nix = {
                board = "bcm2712"; # Raspberry Pi 5
                pin-inputs.enable = true; # pin inputs to latest cachix build
              };
              hardware.raspberry-pi = {
                config.all.base-dt-params = {
                  nvme = {
                    enable = true;
                  };
                  pciex1_gen = {
                    enable = true;
                    value = 3;
                  };
                };
              };
            }
            inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            inputs.raspberry-pi-nix.nixosModules.sd-image
            agenix.nixosModules.default
          ];
        };

        printerpi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs agenix sshkeys; };
          modules = [
            ./systems/printerpi/config.nix
            ./systems/wifi-config.nix # gitignored, see wifi-config-template.nix
            {
              raspberry-pi-nix = {
                board = "bcm2711"; # Raspberry Pi 4
                pin-inputs.enable = true; # pin inputs to latest cachix build
              };
            }
            inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            inputs.raspberry-pi-nix.nixosModules.sd-image
            agenix.nixosModules.default
          ];
        };

        # Local desktops
        edward-desktop-01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs agenix sshkeys; };
          modules = [
            ./systems/edward-desktop-01/config.nix
            ./systems/edward-desktop-01/hardware.nix
            agenix.nixosModules.default
          ];
        };
        edward-laptop-01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs agenix sshkeys; };
          modules = [
            ./systems/edward-laptop-01/config.nix
            ./systems/edward-laptop-01/hardware.nix
            ./systems/edward-laptop-01/specialisations/away.nix
            agenix.nixosModules.default
          ];
        };

        # AWS EC2 nodes.
        # 18.135.222.143
        edwardh = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs sshkeys; };
          modules = [
            "${nixpkgs}/nixos/modules/virtualisation/amazon-image.nix"
            ./systems/edwardh/config.nix
            agenix.nixosModules.default
          ];
        };

        # Old Dell desktop machine.
        edward-dell-01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs agenix sshkeys; };
          modules = [
            ./systems/edward-dell-01/config.nix
            ./systems/edward-dell-01/hardware.nix
            agenix.nixosModules.default
          ];
        };
      };

      # SD card images. Also works for NVME drives!
      rpi5-01-sd = nixosConfigurations.rpi5-01.config.system.build.sdImage;
      printerpi-sd = nixosConfigurations.printerpi.config.system.build.sdImage;

      # deploy-rs configuration
      deploy.nodes = {
        gateway = {
          hostname = "gateway.edwardh.lan";
          profiles.system = {
            sshUser = "headb";
            user = "root";
            remoteBuild = false;
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.gateway;
          };
        };
        rpi5-01 = {
          hostname = "rpi5-01.lan";
          profiles.system = {
            sshUser = "headb";
            user = "root";
            remoteBuild = true; # aarch64-linux builds are faster on aarch64-linux :)
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rpi5-01;
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      homeConfigurations = {
        "headb@gateway" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/gateway/users/headb.nix ];
        };
        "headb@rpi5-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/rpi5-01/users/headb.nix ];
        };
        "headb@printerpi" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/printerpi/users/headb.nix ];
        };
        "headb@edward-desktop-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edward-desktop-01/users/headb.nix ];
        };
        "headb@edward-laptop-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edward-laptop-01/users/headb.nix ];
        };
        "headb@edward-dell-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edward-dell-01/users/headb.nix ];
        };
      };
    };
}
