{
  baseConfig = import ./baseConfig.nix;
  git = import ./git.nix;
  nautilusBookmarks = import ./nautilusBookmarks.nix;
  neovim = import ./neovim.nix;
  zsh = import ./zsh.nix;
}
