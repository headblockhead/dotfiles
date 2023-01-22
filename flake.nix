{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
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

  outputs = inputs@{ self, nixpkgs, home-manager, playdatesdk, xc, mcpelauncher, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
      overlays = [
      (self: super: {
        unityhub = super.callPackage ./custom-packages/unityhub.nix { };
        pdc = playdatesdk.packages.x86_64-linux.pdc;
        pdutil = playdatesdk.packages.x86_64-linux.pdutil;
        PlaydateSimulator = playdatesdk.packages.x86_64-linux.PlaydateSimulator;
        xc = xc.packages.x86_64-linux.xc;
        mcpelauncher = mcpelauncher.defaultPackage.x86_64;
    })
  ];
};
    in {
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
      };
      homeConfigurations = {
      edwards-laptop-headb = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/edwards-laptop-headb.nix ];
      };
      edwards-laptop-2-headb  = home-manager.lib.homeManagerConfiguration { 
        inherit pkgs;
        modules = [ ./home-manager/edwards-laptop-2-headb.nix ];
      };
    };
    };
}
