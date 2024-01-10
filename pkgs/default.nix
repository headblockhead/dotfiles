# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, inputs }: {
  attic = inputs.attic.packages.x86_64-linux.default;
  immersed = pkgs.callPackage ../custom-packages/immersed-vr.nix { };
  alvr = pkgs.callPackage ../custom-packages/alvr.nix { };
  prismlauncher = inputs.prismlauncher.packages.x86_64-linux.prismlauncher;
  pdc = inputs.playdatesdk.packages.x86_64-linux.pdc;
  pdutil = inputs.playdatesdk.packages.x86_64-linux.pdutil;
  PlaydateSimulator = inputs.playdatesdk.packages.x86_64-linux.PlaydateSimulator;
  playdatemirror = inputs.playdatemirror.packages.x86_64-linux.Mirror;
  xc = inputs.xc.packages.x86_64-linux.xc;
  mcpelauncher = inputs.mcpelauncher.defaultPackage.x86_64-linux;
  ##platformio = unstablepkgs.platformio;
  home-manager = inputs.home-manager;
  ##  openrgb = super.libsForQt5.callPackage ./custom-packages/openrgb.nix {
  ##wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
  ##qtbase = pkgs.qt5.qtbase;
  ##qttools = pkgs.qt5.qttools;
  ##qmake = pkgs.qt5.qmake;
  ##};
  templ = inputs.templ.packages.x86_64-linux.default;
  # example = pkgs.callPackage ./example { };
}
