{ outputs
, ...
}:
{
  imports = with outputs.homeManagerModules; [
    atticAutoPush
    baseConfig
    dconf
    fzf
    git
    gnomeTerminal
    gtk
    nautilusBookmarks
    neovim
    openrgb
    zsh
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "headb";
  home.homeDirectory = "/home/headb";
  home.enableNixpkgsReleaseCheck = true;

  home.packages = [
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.file.".config/monitors.xml".text = builtins.readFile ../monitors.xml;

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
