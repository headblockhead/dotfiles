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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, playdatesdk, xc, ... }:
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
            ./nixos/configuration.nix
            ./nixos/hardware-configuration.nix
          ];
        };
      };
      homeConfigurations.headb = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/home.nix ];
      };
    };
}
