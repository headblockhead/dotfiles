{
  description = "Reproducable configuration for all of my devices and gadgets. Now including netbooting!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
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

  outputs =
    { self
    , nixpkgs
    , home-manager
    , agenix
    , ...
    }@ inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
      ];

      # My public SSH key:
      sshkey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvr2FrC9i1bjoVzg+mdytOJ1P0KRtah/HeiMBuKD3DX cardno:23_836_181'';

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    rec {
      # Custom packages: accessible through 'nix build', 'nix shell', etc.
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; inherit inputs; });

      # Exported overlays. Includes custom packages and flake outputs.
      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      #nix-minecraft.overlay

      nixosConfigurations = {
        # Network nodes.

        # Build nodes.

        # Client nodes.
        edward-desktop-01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            ./systems/edward-desktop-01/config.nix
            ./systems/edward-desktop-01/hardware.nix

            agenix.nixosModules.default
          ];
        };
        edward-laptop-01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            ./systems/edwards-laptop/config.nix
            ./systems/edwards-laptop/hardware.nix

            agenix.nixosModules.default
          ];
        };
        edward-laptop-02 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            ./systems/edwards-laptop-2/config.nix
            ./systems/edwards-laptop-2/hardware.nix

            agenix.nixosModules.default
          ];
        };

        # AWS EC2 nodes.
        barkup = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            "${nixpkgs}/nixos/modules/virtualisation/amazon-image.nix"
            ./systems/barkup/config.nix

            agenix.nixosModules.default
          ];
        };

        # Raspberry Pi cluster nodes.
        rpi-cluster-01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; systemname = "rpi-cluster-01"; systemserial = "01-dc-a6-32-31-50-3b"; };
          system = "aarch64-linux";
          modules = [
            #            "${nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix" # Netboot system - Kernel and ramdisk builds.
            ./systems/rpi-cluster/01.nix # This system's configuration
            ./systems/rpi-cluster/hardware.nix # Shared hardware configuration for Raspberry Pis

            #            "${nixpkgs}/nixos/modules/profiles/base.nix" # Base system - various utilities.

            #            nixosModules.rpiTFTP

            agenix.nixosModules.default
          ];
        };
      };

      deploy.nodes.edward-laptop-01.profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.edward-laptop-01;
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

      # Netboot outputs.
      netboot.rpi-cluster-01.rpiTFTP = nixosConfigurations.rpi-cluster-01.config.system.build.rpiTFTP;

      homeConfigurations = {
        "headb@edward-desktop-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edward-desktop-01/users/headb.nix ];
        };
        "headb@edward-laptop-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edward-laptop-01/users/headb.nix ];
        };
        "headb@edward-laptop-02" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edward-laptop-02/users/headb.nix ];
        };
        "headb@barkup" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/barkup/users/headb.nix ];
        };
      };
    };
}
