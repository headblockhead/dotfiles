{ outputs
, pkgs
, ...
}:
{

  imports = with outputs.homeManagerModules; [
    appsMinimal
    appsUseful
    appsExtra
    baseConfig
    dconf
    fzf
    git
    gnome
    gnome-terminal
    go
    gtk-custom-bookmarks
    gtk
    neovim
    obinskit
    picosdk
    playdatesdk
    terminalutils
    unity
    # vscode
    zsh
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "headb";
  home.homeDirectory = "/home/headb";
  home.enableNixpkgsReleaseCheck = true;

  home.packages = [
    pkgs.godot_4
    pkgs.immersed
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-25.9.0"
        "electron-13.6.9"
      ];
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
