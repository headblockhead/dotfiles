{ inputs, ... }: {
  # Add custom packages to nixpkgs from our definitions in the 'pkgs' folder.
  additions = final: _prev: import ../pkgs { pkgs = final; inherit inputs; system = final.system; };

  # Modify existing packages in nixpkgs.
  modifications = final: prev: {
    google-chrome = prev.google-chrome.overrideAttrs (oldAttrs: {
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--disable-features=WaylandFractionalScaleV1"
      ];
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
