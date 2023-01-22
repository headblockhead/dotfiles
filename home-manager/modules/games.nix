{ pkgs, ... }: {
  home.packages = with pkgs; [
  prismlauncher
  steam
  mcpelauncher # Not in nixpkgs, defined by override in flake.nix (source: github.com/headblockhead/nix-mcpelauncher)
  ];
}
