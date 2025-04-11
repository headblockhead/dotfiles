{
  description = "Reproducable NixOS (and homemanager) config for my local servers, cloud servers, desktops, and laptops.";

  nixConfig = {
    extra-substituters = [ "http://cache.edwardh.dev" ];
    extra-trusted-public-keys = [
      "cache.edwardh.dev-1:/i5z0aYaRDBcT8Qf9uDFi8z0FEKIZsK7RVZLMKNJMGg="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master"; # Very unstable! Useful for same-day hotfixes.

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    agenix.url = "github:ryantm/agenix";

    edwardh-dev.url = "github:headblockhead/edwardh.dev";
  };

  outputs =
    { self, nixpkgs, home-manager, agenix, deploy-rs, edwardh-dev, ... }@ inputs:
    let
      inherit (self) outputs;

      # System types we want to build our packages for, used to generate pkgs.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      sshkeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvr2FrC9i1bjoVzg+mdytOJ1P0KRtah/HeiMBuKD3DX cardno:23_836_181" # crystal-peak
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIvDaJmOSXV24B83sIfZqAUurs+cZ7582L4QDePuc3p7 cardno:17_032_332" # depot-37
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBexdKZYlyseEcm1S3xNDqPTGZMfm/NcW1ygY91weDhC cardno:30_797_561" # thunder-mountain
      ];

      account = {
        username = "headb";
        realname = "Edward Hesketh";
      };

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
          specialArgs = { inherit inputs outputs sshkeys account; };
          modules = [
            ./systems/gateway/config.nix
            ./systems/gateway/hardware.nix
          ];
        };

        rpi5-01 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs sshkeys account; };
          modules = [
            ./systems/rpi5-01/config.nix
            ./systems/rpi5-01/hardware.nix
            inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            inputs.raspberry-pi-nix.nixosModules.sd-image
            agenix.nixosModules.default
          ];
        };

        rpi4-01 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs sshkeys account; };
          modules = [
            ./systems/rpi4-01/config.nix
            ./systems/rpi4-01/hardware.nix
            ./systems/wifi-config.nix # gitignored, see wifi-config-template.nix
            inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            inputs.raspberry-pi-nix.nixosModules.sd-image
          ];
        };

        # Local clients
        edward-desktop-01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs sshkeys account; };
          modules = [
            ./systems/edward-desktop-01/config.nix
            ./systems/edward-desktop-01/hardware.nix
          ];
        };
        edward-laptop-01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs sshkeys account; };
          modules = [
            ./systems/edward-laptop-01/config.nix
            ./systems/edward-laptop-01/hardware.nix
          ];
        };

        # AWS EC2 nodes
        edwardh = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs sshkeys account edwardh-dev; };
          modules = [
            ./systems/edwardh/config.nix
            "${nixpkgs}/nixos/modules/virtualisation/amazon-image.nix"
            agenix.nixosModules.default
          ];
        };

        # Old Dell desktop machine.
        edward-dell-01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs sshkeys account; };
          modules = [
            ./systems/edward-dell-01/config.nix
            ./systems/edward-dell-01/hardware.nix
          ];
        };
      };

      # SD card images. Also works for NVME drives!
      rpi5-01-sd = nixosConfigurations.rpi5-01.config.system.build.sdImage;
      printerpi-sd = nixosConfigurations.printerpi.config.system.build.sdImage;

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
        "headb@rpi4-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/rpi4-01/users/headb.nix ];
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
