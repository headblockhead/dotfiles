{ config, pkgs,... }:

{
  # Home Manager needs a bit of information about you and the
# paths it should manage.
home.username = "headb";
home.homeDirectory = "/home/headb";
home.enableNixpkgsReleaseCheck = true;

# Don't show home-manager news
news.display = "silent";

# Packages for this user.
home.packages = [
  pkgs.xc # Not in nixpkgs, overlayed by github:joerdav/xc. See flake.nix.
  pkgs.gnomeExtensions.appindicator # When apps 'minimise to tray' this is where they go
  pkgs.audacity # Audio app
  pkgs.nixfmt # a command line tool to fix ugly .nix files
  pkgs.google-chrome # Web Browser
  pkgs.deja-dup # Backup software
  pkgs.vlc # Video and audio player
  pkgs.oh-my-zsh # ZSH customiser
  pkgs.gopls # Go programming language formatting tools
  pkgs.nodePackages.prettier # Code tidier
  pkgs.nixpkgs-fmt # Nix formatting tools
  pkgs.kdenlive # Video editing software
  pkgs.gimp # Image editing software
  pkgs.spotify # Desktop music player
  pkgs.thunderbird # Email client
  pkgs.adwaita-qt # QT theme to bend Qt applications to look like they belong into GNOME Shell
  pkgs.gnome.gnome-terminal # Gnome terminal
];

# Configure installed packages
# https://github.com/nix-community/home-manager/tree/master/modules/programs

qt = {
  enable = true;
  style = { name = "adwaita-dark"; };
  platformTheme = "gtk";
};
gtk = {
  enable = true;
  theme = {
    name = "Adwaita-dark"; # Enable dark mode for GTK2
  };
  iconTheme = { name = "Adwaita"; };
  gtk2.extraConfig = ''gtk-application-prefer-dark-theme = "true"'';
  gtk3.extraConfig = { "gtk-application-prefer-dark-theme" = "true"; };
  gtk4.extraConfig = { "gtk-application-prefer-dark-theme" = "true"; };
};
dconf = {
  enable = true;
  settings = {
    "org/gnome/deja-dup" = {
      periodic = true;
      periodic-period = 1;
      delete-after = 0;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      color-scheme = "prefer-dark"; # Enable dark mode on GNOME
    };
    "org/gnome/nautilus/compression" = { default-compression-format = "7z"; };
    "org/gnome/nautilus/icon-view" = { default-zoom-level = "medium"; };
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
      use-tree-view = true;
      default-column-order = [
        "name"
        "size"
        "type"
        "owner"
        "group"
        "permissions"
        "mime_type"
        "where"
        "date_modified"
        "date_modified_with_time"
        "date_accessed"
        "date_created"
        "recency"
        "starred"
      ];
      default-visible-columns = [ "name" "size" "date_modified" ];
    };
  };
};
programs.fzf = {
  enable = true;
  enableZshIntegration = true;
  defaultOptions =
    [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
};
programs.gnome-terminal = {
  enable = true;
  showMenubar = false;
  profile = {
    "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
      default = true;
      visibleName = "Nix Custom";
      cursorShape = "block";
      font = "SauceCodePro Nerd Font 12"; # Size: 12
      showScrollbar = false;
      colors = {
        backgroundColor = "#000000";
        foregroundColor = "#ffffff";
        palette = [
          "#000000"
          "#aa0000"
          "#00aa00"
          "#aa5500"
          "#0000aa"
          "#aa00aa"
          "#00aaaa"
          "#aaaaaa"
          "#555555"
          "#ff5555"
          "#55ff55"
          "#ffff55"
          "#5555ff"
          "#ff55ff"
          "#55ffff"
          "#ffffff"
        ];
      };
    };
  };
};
programs.zsh = {
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  enableSyntaxHighlighting = true;
  oh-my-zsh = {
    enable = true;
    plugins = [ "aws" "git" ];
  };
  initExtra = ''
    source ~/custom.zsh-theme
    export PATH="$GOBIN:$PATH"
    export ZSH_HIGHLIGHT_STYLES[comment]=fg=245,bold
    export NIXPKGS_ALLOW_UNFREE=1
    export PLAYDATE_SDK_PATH=~/playdatesdk-1.12.3
  '';
  plugins = [
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "0.7.1";
        sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
      };
    }
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.5.0";
        sha256 = "IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
      };
    }
  ];
  shellAliases = {
    q = "exit";
    p = "gopass show -c -n";
    ls = "ls --color=tty -A";
  };
  sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
};
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
