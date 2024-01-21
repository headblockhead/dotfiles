{
  appsExtra = import ./appsExtra.nix;
  appsMinimal = import ./appsMinimal.nix;
  appsUseful = import ./appsUseful.nix;
  baseConfig = import ./baseConfig.nix;
  dconf = import ./dconf.nix;
  fzf = import ./fzf.nix;
  git = import ./git.nix;
  gnome = import ./gnome.nix;
  gnome-terminal = import ./gnome-terminal.nix;
  go = import ./go.nix;
  gtk-custom-bookmarks = import ./gtk-custom-bookmarks.nix;
  gtk = import ./gtk.nix;
  neovim = import ./neovim.nix;
  obinskit = import ./obinskit.nix;
  openrgb = import ./openrgb.nix;
  picosdk = import ./picosdk.nix;
  playdatesdk = import ./playdatesdk.nix;
  terminalutils = import ./terminalutils.nix;
  unity = import ./unity.nix;
  vscode = import ./vscode.nix;
  zsh = import ./zsh.nix;
}
