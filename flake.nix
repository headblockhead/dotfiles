{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    rpi-nixpkgs.url = "github:NixOS/nixpkgs/d91e1f9";

    unstablenixpkgs.url = "nixpkgs/nixos-unstable";
    oldnixpkgs.url = "nixpkgs/nixos-21.05";
    csharpnixpkgs.url = "github:NixOS/nixpkgs/fd78240";
    unitynixpkgs.url = "github:NixOS/nixpkgs/afb1ed8";
    vscodeutilsnixpkgs.url = "nixpkgs/nixos-22.11";
    xmrignixpkgs.url = "nixpkgs/nixos-22.11";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
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
    templ = {
      url = "github:a-h/templ";
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

  outputs = inputs@{ self, agenix, unstablenixpkgs, vscodeutilsnixpkgs, nixpkgs, prismlauncher, rpi-nixpkgs, csharpnixpkgs, unitynixpkgs, oldnixpkgs, home-manager, playdatesdk, playdatemirror, templ, xc, mcpelauncher, xmrignixpkgs, ... }:
    let
      system = "x86_64-linux";
      sshkey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvr2FrC9i1bjoVzg+mdytOJ1P0KRtah/HeiMBuKD3DX cardno:23_836_181'';

      oldpkgs = import oldnixpkgs { };
      unstablepkgs = import unstablenixpkgs { };
      unitypkgs = import unitynixpkgs { };
      vscodeutilspkgs = import vscodeutilsnixpkgs { };
      csharppkgs = import csharpnixpkgs { };
      xmrigpkgs = import xmrignixpkgs { };

      pkgs = import nixpkgs {
        allowUnfree = true;
        cudaSupport = true;
        overlays = [
          inputs.nix-minecraft.overlay
          (self: super: {
            vscode-extensions.ms-dotnettools.csharp = csharppkgs.vscode-extensions.ms-dotnettools.csharp;
            obinskit = super.callPackage ./custom-packages/obinskit.nix { };
            immersed = super.callPackage ./custom-packages/immersed-vr.nix {
              ffmpeg-full = unstablepkgs.ffmpeg-full;
              pkgs = unstablepkgs;
              libvaDriverName = "i965";
            };
            rpi-imager = super.callPackage ./custom-packages/rpi-imager.nix {
              cmake = pkgs.cmake;
              curl = pkgs.curl;
              libarchive = pkgs.libarchive;
              util-linux = pkgs.util-linux;
              qtbase = pkgs.qt5.qtbase;
              qtdeclarative = pkgs.qt5.qtdeclarative;
              qtsvg = pkgs.qt5.qtsvg;
              qttools = pkgs.qt5.qttools;
              qtquickcontrols2 = pkgs.qt5.qtquickcontrols2;
              qtgraphicaleffects = pkgs.qt5.qtgraphicaleffects;
              wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
            };
            alvr = super.callPackage ./custom-packages/alvr.nix { };
            unityhub = unitypkgs.unityhub;
            thonny = oldpkgs.thonny;
            prismlauncher = inputs.prismlauncher.packages.x86_64-linux.prismlauncher;
            pdc = playdatesdk.packages.x86_64-linux.pdc;
            pdutil = playdatesdk.packages.x86_64-linux.pdutil;
            PlaydateSimulator = playdatesdk.packages.x86_64-linux.PlaydateSimulator;
            playdatemirror = inputs.playdatemirror.packages.x86_64-linux.Mirror;
            xc = inputs.xc.packages.x86_64-linux.xc;
            mcpelauncher = inputs.mcpelauncher.defaultPackage.x86_64-linux;
            platformio = unstablepkgs.platformio;
            vscode = vscodeutilspkgs.vscode;
            vscode-utils = vscodeutilspkgs.vscode-utils;
            flyctl = unstablepkgs.flyctl;
            home-manager = inputs.home-manager;
            openrgb = super.libsForQt5.callPackage ./custom-packages/openrgb.nix {
              wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
              qtbase = pkgs.qt5.qtbase;
              qttools = pkgs.qt5.qttools;
              qmake = pkgs.qt5.qmake;
            };
            templ = inputs.templ.packages.x86_64-linux.default;
            openrgb-with-all-plugins = unstablepkgs.openrgb-with-all-plugins;
            xmrig = xmrigpkgs.xmrig;
          })
        ];
      };
    in
    rec {
      # Allow self referencing.
      nixosConfigurations = {
        compute-01 = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs; inherit agenix; inherit sshkey; };
          modules = [
            ./nixos/compute-01-config.nix
            ./nixos/compute-01-hardware.nix

            agenix.nixosModules.default
          ];
        };
        edwards-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs; inherit agenix; inherit sshkey; };
          modules = [
            ./nixos/edwards-laptop-config.nix
            ./nixos/edwards-laptop-hardware.nix

            agenix.nixosModules.default
          ];
        };
        edwards-laptop-2 = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs; inherit agenix; inherit sshkey; };
          modules = [
            ./nixos/edwards-laptop-2-config.nix
            ./nixos/edwards-laptop-2-hardware.nix

            agenix.nixosModules.default
          ];
        };
        barkup-ec2 = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs; inherit sshkey; };
          modules = [
            ./nixos/barkup-ec2-conf.nix
            "${nixpkgs}/nixos/modules/virtualisation/amazon-image.nix"

            agenix.nixosModules.default
          ];
        };
        rpi-headless-image = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; inherit sshkey; };
          modules = [
            "${rpi-nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
            ./nixos/rpi-headless-image-conf.nix
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.crossSystem.system = "aarch64-linux";
            }

            agenix.nixosModules.default
          ];
        };
      };
      images.rpi-headless-image = nixosConfigurations.rpi-headless-image.config.system.build.sdImage;
      homeConfigurations = {
        compute-01-headb = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/compute-01-headb.nix ];
        };
        edwards-laptop-headb = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/edwards-laptop-headb.nix ];
        };
        edwards-laptop-2-headb = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/edwards-laptop-2-headb.nix ];
        };
        barkup-ec2-headb = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/barkup-ec2-headb.nix ];
        };
        rpi-generic-nixos-pi = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/rpi-generic-nixos-pi.nix ];
        };
      };
    };
}
