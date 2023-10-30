{ pkgs, ... }:

{

  imports = [
    ./modules/basehomemanagersettings.nix
    ./modules/dconf.nix

    ./modules/everydayapps.nix

    #    ./modules/extraapps.nix
    ./modules/fzf.nix
    #    ./modules/games.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/gnome-terminal.nix
    #    ./modules/go.nix
    #    ./modules/gtk-custom-bookmarks.nix
    ./modules/gtk.nix
    ./modules/neovim.nix
    #    ./modules/obinskit.nix
    #    ./modules/picosdk.nix
    #    ./modules/playdatesdk.nix
    ./modules/qt.nix
    ./modules/terminalutils.nix
    #    ./modules/unity.nix
    #    ./modules/vscode.nix

    ./modules/zsh.nix
    #    ./modules/zshminimal.nix
  ];

  home.packages = [
    pkgs.furnace # chiptune tracker
    pkgs.rpi-imager
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "headb";
  home.homeDirectory = "/home/headb";
  home.enableNixpkgsReleaseCheck = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
