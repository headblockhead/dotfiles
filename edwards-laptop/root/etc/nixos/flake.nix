{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs @ { self, nixpkgs, home-manager }:
    let system = "x86_64-linux"; in {
      nixosConfigurations = {
        edwards-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
                        ({ pkgs, ... }: {
              environment.etc."nix/channels/nixpkgs".source = inputs.nixpkgs.outPath;
              environment.etc."nix/channels/home-manager".source = inputs.home-manager.outPath;

              nix.nixPath = [ 
                "nixpkgs=/etc/nix/channels/nixpkgs"
                "home-manager=/etc/nix/channels/home-manager"
              ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
    })
            inputs.home-manager.nixosModules.home-manager # make home manager available to configuration.nix
            ./configuration.nix
            ./hardware-configuration.nix
          ];
        };
      };
    };
}
