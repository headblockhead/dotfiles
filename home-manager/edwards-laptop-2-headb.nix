{ config, pkgs,... }:

{

  imports = [
    ./modules/dconf.nix
    ./modules/everydayapps.nix
    ./modules/fzf.nix
    ./modules/gnome.nix
    ./modules/gnome-terminal.nix
    ./modules/gtk.nix
    ./modules/neovim.nix
    ./modules/qt.nix
    ./modules/terminalutils.nix
    ./modules/zsh-minimal.nix
  ];
  # Home Manager needs a bit of information about you and the
# paths it should manage.
home.username = "headb";
home.homeDirectory = "/home/headb";
home.enableNixpkgsReleaseCheck = true;

# Don't show home-manager news
news.display = "silent";

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
