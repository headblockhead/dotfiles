{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
        compute-01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            ./systems/compute-01/config.nix
            ./systems/compute-01/hardware.nix

            agenix.nixosModules.default
          ];
        };
        edwards-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            ./systems/edwards-laptop/config.nix
            ./systems/edwards-laptop/hardware.nix

            agenix.nixosModules.default
          ];
        };
        edwards-laptop-2 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            ./systems/edwards-laptop-2/config.nix
            ./systems/edwards-laptop-2/hardware.nix

            agenix.nixosModules.default
          ];
        };
        barkup-ec2 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          modules = [
            ./systems/barkup-ec2/config.nix
            "${nixpkgs}/nixos/modules/virtualisation/amazon-image.nix"

            agenix.nixosModules.default
          ];
        };
        rpi-network-server = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs agenix sshkey; };
          system = "x86_64-linux";
          modules = [
            #            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
            "${nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix"
            ./systems/rpi-network-server/config.nix
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.crossSystem.system = "aarch64-linux";
            }
            agenix.nixosModules.default
          ];
        };
      };
      netboot.rpi-network-server = nixosConfigurations.rpi-network-server.config.system.build.kernel;
      homeConfigurations = {
        "headb@compute-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/compute-01/users/headb.nix ];
        };
        "headb@edwards-laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edwards-laptop/users/headb.nix ];
        };
        "headb@edwards-laptop-2" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edwards-laptop-2/users/headb.nix ];
        };
        "headb@barkup" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/barkup-ec2/users/headb.nix ];
        };
      };
    };
}
