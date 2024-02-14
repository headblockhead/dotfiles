# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; inherit inputs; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    google-chrome = prev.google-chrome.overrideAttrs (oldAttrs: {
      # Google Chrome for web development.
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--disable-features=WaylandFractionalScaleV1"
      ];
    });
    blender = prev.blender.overrideAttrs (oldAttrs: {
      cudaSupport = true;
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
