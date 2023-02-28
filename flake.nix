{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    oldnixpkgs.url = "nixpkgs/nixos-21.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    playdatesdk = {
      url = "github:headblockhead/nix-playdatesdk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xc = {
      url = "github:joerdav/xc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcpelauncher = {
      url = "github:headblockhead/nix-mcpelauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self,  nixpkgs, oldnixpkgs, home-manager, playdatesdk, xc, mcpelauncher, ... }:
    let
      system = "x86_64-linux";
      oldpkgs = import oldnixpkgs{};
      pkgs = import nixpkgs {
        overlays = [
          (self: super: {
            unityhub = super.callPackage ./custom-packages/unityhub.nix { 
              inherit pkgs;
            };
            thonny = oldpkgs.thonny;
            pdc = playdatesdk.packages.x86_64-linux.pdc;
            pdutil = playdatesdk.packages.x86_64-linux.pdutil;
            PlaydateSimulator = playdatesdk.packages.x86_64-linux.PlaydateSimulator;
            xc = xc.packages.x86_64-linux.xc;
            mcpelauncher = mcpelauncher.defaultPackage.x86_64-linux;
          })
        ];
      };
    in rec { # Allow self referencing.
      nixosConfigurations = {
        edwards-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ({ pkgs, ... }: {
              environment.etc."nix/channels/nixpkgs".source = inputs.nixpkgs.outPath;
              nix.nixPath = [ "nixpkgs=/etc/nix/channels/nixpkgs" ];
            })
            ./nixos/edwards-laptop-config.nix
            ./nixos/edwards-laptop-hardware.nix
          ];
        };
        edwards-laptop-2 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ({ pkgs, ... }: {
              environment.etc."nix/channels/nixpkgs".source = inputs.nixpkgs.outPath;
              nix.nixPath = [ "nixpkgs=/etc/nix/channels/nixpkgs" ];
            })
            ./nixos/edwards-laptop-2-config.nix
            ./nixos/edwards-laptop-2-hardware.nix
          ];
        };
        rpi-headless-image = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
            ./nixos/rpi-headless-image-conf.nix
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.crossSystem.system = "aarch64-linux";
                          }
          ];
        };
        rpi-home-assistant =nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/rpi-home-assistant-conf.nix
            ./nixos/rpi-home-assistant-hardware.nix
          ];
        };
        rpi-generic-nixos =nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
modules = [
            ./nixos/rpi-generic-nixos-conf.nix
            ./nixos/rpi-generic-nixos-hardware.nix
          ];

        };
      };
      images.rpi-headless-image = nixosConfigurations.rpi-headless-image.config.system.build.sdImage;
      homeConfigurations = {
        edwards-laptop-headb = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/edwards-laptop-headb.nix ];
        };
        edwards-laptop-2-headb = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/edwards-laptop-2-headb.nix ];
        };
        rpi-generic-nixos-pi = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/rpi-generic-nixos-pi.nix ];
        };
      };
    };
}
