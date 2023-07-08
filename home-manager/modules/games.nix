{ pkgs, ... }: {
  home.packages = with pkgs; [
    immersed # Not in nixpkgs, defined by override in flake.nix (source: github.com/nix-community/nur-combined/blob/master/repos/noneucat/pkgs/immersed/default.nix)
  prismlauncher
  steam
  mcpelauncher # Not in nixpkgs, defined by override in flake.nix (source: github.com/headblockhead/nix-mcpelauncher)
  ];
}
