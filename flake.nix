{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    rpi-nixpkgs.url = "github:NixOS/nixpkgs/d91e1f9";
    unstablenixpkgs.url = "nixpkgs/nixos-unstable";
    oldnixpkgs.url = "nixpkgs/nixos-21.05";
    csharpnixpkgs.url = "github:NixOS/nixpkgs/fd78240";
    unitynixpkgs.url = "github:NixOS/nixpkgs/afb1ed8";
    vscodeutilsnixpkgs.url = "nixpkgs/nixos-22.11";
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    playdatesdk = {
      url = "github:headblockhead/nix-playdatesdk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    playdatemirror = {
      url = "github:headblockhead/nix-playdatemirror";
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

  outputs = inputs@{ self, unstablenixpkgs, vscodeutilsnixpkgs, nixpkgs, prismlauncher, rpi-nixpkgs, csharpnixpkgs,unitynixpkgs, oldnixpkgs, home-manager, playdatesdk, playdatemirror,xc, mcpelauncher, ... }:
    let
      system = "x86_64-linux";
      oldpkgs = import oldnixpkgs{};
      unstablepkgs = import unstablenixpkgs {};
      unitypkgs = import unitynixpkgs {};
      vscodeutilspkgs = import vscodeutilsnixpkgs {};
      csharppkgs = import csharpnixpkgs {};
      pkgs = import nixpkgs {
        overlays = [
          (self: super: {
            vscode-extensions.ms-dotnettools.csharp = csharppkgs.vscode-extensions.ms-dotnettools.csharp;
            obinskit = super.callPackage ./custom-packages/obinskit.nix { };
            immersed = super.callPackage ./custom-packages/immersed-vr.nix { 
              ffmpeg-full = unstablepkgs.ffmpeg-full;
              pkgs = unstablepkgs;
              libvaDriverName = "i965";
            };
            unityhub = unitypkgs.unityhub;
            thonny = oldpkgs.thonny;
            prismlauncher = prismlauncher.packages.x86_64-linux.prismlauncher;
            pdc = playdatesdk.packages.x86_64-linux.pdc;
            pdutil = playdatesdk.packages.x86_64-linux.pdutil;
            PlaydateSimulator = playdatesdk.packages.x86_64-linux.PlaydateSimulator;
            playdatemirror = playdatemirror.packages.x86_64-linux.Mirror;
            xc = xc.packages.x86_64-linux.xc;
            mcpelauncher = mcpelauncher.defaultPackage.x86_64-linux;
            platformio = unstablepkgs.platformio;
            vscode = vscodeutilspkgs.vscode;
            vscode-utils = vscodeutilspkgs.vscode-utils;
            home-manager = home-manager;
          })
        ];
      };
    in rec { # Allow self referencing.
      nixosConfigurations = {
        edwards-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/edwards-laptop-config.nix
            ./nixos/edwards-laptop-hardware.nix
          ];
        };
        edwards-laptop-2 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/edwards-laptop-2-config.nix
            ./nixos/edwards-laptop-2-hardware.nix
          ];
        };
        rpi-headless-image = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${rpi-nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
            ./nixos/rpi-headless-image-conf.nix
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.crossSystem.system = "aarch64-linux";
                          }
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
