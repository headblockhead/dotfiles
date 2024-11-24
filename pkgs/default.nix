# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, system, inputs }: {
  home-manager = inputs.home-manager.defaultPackage.${system};

  templ = inputs.templ.packages.${system}.default;
  deploy-rs = inputs.deploy-rs.packages.${system}.default;
  prismlauncher = inputs.prismlauncher.packages.${system}.prismlauncher;
  mcpelauncher = inputs.mcpelauncher.defaultPackage.${system};

  pdc = inputs.playdatesdk.packages.${system}.pdc;
  pdutil = inputs.playdatesdk.packages.${system}.pdutil;
  PlaydateSimulator = inputs.playdatesdk.packages.${system}.PlaydateSimulator;
  playdatemirror = inputs.playdatemirror.packages.${system}.Mirror;

  librespot = pkgs.callPackage ../custom-packages/librespot.nix { };
  picotool = pkgs.callPackage ../custom-packages/picotool.nix {
    pico-sdk = pkgs.callPackage ../custom-packages/pico-sdk.nix { };
  };
  pico-sdk = pkgs.callPackage ../custom-packages/pico-sdk.nix { };

  openrgb = pkgs.libsForQt5.callPackage ../custom-packages/openrgb.nix {
    wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
    qtbase = pkgs.qt5.qtbase;
    qttools = pkgs.qt5.qttools;
    qmake = pkgs.qt5.qmake;
  };
  openrgb-plugin-effects = pkgs.callPackage ../custom-packages/openrgb-plugin-effects.nix {
    wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
    qtbase = pkgs.qt5.qtbase;
    qmake = pkgs.qt5.qmake;
  };
  openrgb-plugin-hardwaresync = pkgs.callPackage ../custom-packages/openrgb-plugin-hardwaresync.nix {
    wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
    qtbase = pkgs.qt5.qtbase;
    qmake = pkgs.qt5.qmake;
  };
}
