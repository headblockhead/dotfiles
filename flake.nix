{
  description = "NixOS and Home Manager configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs@{ self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        edwards-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ({ pkgs, ... }: {
              environment.etc."nix/channels/nixpkgs".source =
                inputs.nixpkgs.outPath;
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
