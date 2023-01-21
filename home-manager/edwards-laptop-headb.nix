{ config, pkgs,... }:

let
      pluginGit = owner: repo: ref: sha:
        pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "${repo}";
          version = ref;
         src = pkgs.fetchFromGitHub {
            owner = owner;
            repo = repo;
            rev = ref;
            sha256 = sha;
          };
        };
in {
  # Home Manager needs a bit of information about you and the
# paths it should manage.
home.username = "headb";
home.homeDirectory = "/home/headb";
home.enableNixpkgsReleaseCheck = true;

# Don't show home-manager news
news.display = "silent";

nixpkgs.config.permittedInsecurePackages = [ "electron-13.6.9" ];

# Packages for this user.
home.packages = [
  pkgs.unityhub # Game-making tool - Launcher for Unity. Overlayed by definition in custom-packages/unityhub.nix - nixpkgs is outdated https://github.com/huantianad/nixos-config/blob/main/packages/unityhub.nix.
  pkgs.pdc # PlayDateCompiler - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
  pkgs.pdutil # PlayDateUtility - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
  pkgs.PlaydateSimulator # Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix. 
  pkgs.xc # Not in nixpkgs, overlayed by github:joerdav/xc. See flake.nix.
  pkgs.pico-sdk # RP2040 SDK.
  pkgs.obinskit # Annepro2 configurator
  pkgs.gcc
  pkgs.cmake # C Makefile creator.
  pkgs.silver-searcher # AG - used for vim.
  pkgs.ccls # C langauge server.
  pkgs.wireguard-tools # Wireguard VPN tools.
  pkgs.tinygo # Go programming language complier but for small places
  pkgs.gnomeExtensions.appindicator # When apps 'minimise to tray' this is where they go
  pkgs.sumneko-lua-language-server # Lua language server for vim.
  pkgs.lua5_4 # Lua language
  pkgs.remmina # Remote desktop application.
  pkgs.audacity # Audio app
  pkgs.bat # Cat alternative
  pkgs.steam # Video game distribution platform
  pkgs.cargo # Rust programming language package manager
  pkgs.rustc # Rust programming language compiler
  pkgs.zoom-us # Video conferencing platform
  pkgs.blender # 3D program
  pkgs.transgui # a GUI for managing the Transmission bittorrent client.
  pkgs.nixfmt # a command line tool to fix ugly .nix files
  pkgs.ngrok # share local server remotely
  pkgs.awscli2 # aws command line utility
  pkgs.musescore # music notation software
  pkgs.obs-studio # Streaming and recording software
  pkgs.asciinema # Terminal recorder
  pkgs.onedrive # Cloud storage from school
  pkgs.google-chrome # Web Browser
  #    pkgs.minecraft # Block Game
  pkgs.prismlauncher # Custom Block Game Launcher
  pkgs.cura # 3D Printing Slicer
  pkgs.neofetch # System show-off tool
  pkgs.cmatrix # Pretend you are in The Matrix
  pkgs.gopass # Password manager
  pkgs.gh # GitHub command-line tool
  pkgs.go # Go programming language compiler
  pkgs.vscode # Code editor
  pkgs.p7zip # 7zip compression and extraction tool.
  pkgs.deja-dup # Backup software
  pkgs.vlc # Video and audio player
  pkgs.gnumake # Runs Makefiles
  pkgs.nodejs # Javascript stuff
  pkgs.oh-my-zsh # ZSH customiser
  pkgs.qmk # Keyboard tool
  pkgs.gopls # Go programming language formatting tools
  pkgs.nodePackages.prettier # Code tidier
  pkgs.nixpkgs-fmt # Nix formatting tools
  pkgs.kdenlive # Video editing software
  pkgs.gimp # Image editing software
  pkgs.spotify # Desktop music player
  pkgs.thunderbird # Email client
  pkgs.libreoffice # Microsoft Office alternative for Linux
  pkgs.hugo # Static site generator written in Go
  pkgs.adwaita-qt # QT theme to bend Qt applications to look like they belong into GNOME Shell
  pkgs.gcc-arm-embedded # GCC for ARM
  pkgs.picotool # RP2040 tool for uploading uf2s.
  pkgs.python39 # Python interpreter
  pkgs.minicom # Serial console/modem controller.
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
  gtk3.bookmarks = [ "file:///home/headb/OneDrive" ]; # Set nautilus bookmarks
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
programs.go = {
  enable = true;
  goBin = "go/bin";
  goPath = "go";
  packages = {
    "github.com/go-delve/delve/cmd/dlv" = pkgs.fetchFromGitHub {
      owner = "go-delve";
      repo = "delve";
      rev = "master";
      sha256 = "/26wOIhMaI8FzLfKQq7kV8WcL1F9/ELNRA/9wfy/x8g=";
    };
    "github.com/sago35/tinygo-edit" = pkgs.fetchFromGitHub {
      owner = "sago35";
      repo = "tinygo-edit";
      rev = "master";
      sha256 = "KgC/ReCjZlvnBrQv5vhGvG+7+lV7fd723rQtuV9ezYI=";
    };
  };
};
programs.gh = {
  enable = true;
  settings = {
    git_protocol = "ssh";
    prompt = "enabled";
    editor = "";
    pager = "";
    http_unix_socket = "";
    browser = "";
  };
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
programs.git = {
  enable = true;
  userName = "Edward Hesketh";
  userEmail = "headblockhead@gmail.com";
  difftastic = {
    enable = true;
    background = "dark";
    display = "inline";
  };
  signing = {
    key = "7B485B936DB40FD57939E2A8A5D1F48A8CDD4F44";
    gpgPath = "/run/current-system/sw/bin/gpg2";
    signByDefault = true;
  };
  extraConfig = { pull.rebase = false; };
};
programs.neovim = {
  enable = true;
  viAlias = true;
  vimAlias = true;
  defaultEditor = true;
  plugins = with pkgs.vimPlugins; [
    # Theming plugins
    lualine-nvim
      dracula-nvim
    # Everything else
    # Metal syntax highlighting.
    (pluginGit "tklebanoff" "metal-vim"
      "6970494a5490a17033650849f0a1ad07506cef2e"
      "14i8q9ikp3v4q7mpid9ir1azfqfm7fbksc65cpp51424clnqcapl")
    # Add fuzzy searching (Ctrl-P to search file names, space-p to search content).
    fzf-vim
    # Maintain last location in files.
    vim-lastplace
    # Syntax highlighting for Nix files.
    vim-nix
    # Colour scheme.
    # Use :TSHighlightCapturesUnderCursor to see the syntax under cursor.
      playground
    nvim-treesitter.withAllGrammars
    # Go test coverage highlighting.
    (pluginGit "rafaelsq" "nvim-goc.lua"
      "7d23d820feeb30c6346b8a4f159466ee77e855fd"
      "1b9ri5s4mcs0k539kfhf5zd3fajcr7d4lc0216pbjq2bvg8987wn")
    # General test coverage highlighting.
    (pluginGit "ruanyl" "coverage.vim"
      "1d4cd01e1e99d567b640004a8122be8105046921"
      "1vr6ylppwd61rj0l7m6xb0scrld91wgqm0bvnxs54b20vjbqcsap")
    # Grep plugin to improve grep UX.
    (pluginGit "dkprice" "vim-easygrep"
      "d0c36a77cc63c22648e792796b1815b44164653a"
      "0y2p5mz0d5fhg6n68lhfhl8p4mlwkb82q337c22djs4w5zyzggbc")
    # Templ highlighting.
    (pluginGit "Joe-Davidson1802" "templ.vim"
      "2d1ca014c360a46aade54fc9b94f065f1deb501a"
      "1bc3p0i3jsv7cbhrsxffnmf9j3zxzg6gz694bzb5d3jir2fysn4h")
    # Add function signatures to autocomplete.
      lsp_signature-nvim
    # Configure autocomplete.
    nvim-cmp
    # Configure autocomplete.
      nvim-lspconfig
    # Snippets manager.
    luasnip
    # Add snippets to the autocomplete.
      cmp_luasnip
    # Show diagnostic errors inline.
trouble-nvim
    # Go debugger.
    (pluginGit "sebdah" "vim-delve" "5c8809d9c080fd00cc82b4c31900d1bc13733571"
      "01nlzfwfmpvp0q09h1k1j5z82i925hrl9cg9n6gbmcdqsvdrzy55")
    # Replacement for netrw.
      nvim-web-devicons
    nvim-tree-lua
    # \c to toggle commenting out a line.
    nerdcommenter # preservim/nerdcommenter
    # Work out tabs vs spaces etc. automatically.
    vim-sleuth # tpope/vim-sleuth
    # Change surrounding characters, e.g. cs"' to change from double to single quotes.
    vim-surround # tpope/vim-surround
    vim-test # janko/vim-test
    vim-visual-multi # mg979/vim-visual-multi
    cmp-nvim-lsp
    targets-vim # https://github.com/wellle/targets.vim
  ];
  extraConfig = "lua require('init')";
  #      " Don't spill gopass secrets.
  #      au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
  #    '';
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
    if [ ! -d ~/pico-sdk ]
    then
      git clone https://github.com/raspberrypi/pico-sdk.git ~/pico-sdk
      git -C ~/pico-sdk submodule update --init ~/pico-sdk
      cp -r ${pkgs.pico-sdk}/lib/pico-sdk ~/pico-sdk
    fi
    export PICO_SDK_PATH="~/pico-sdk"
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
  sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; PLAYDATE_SDK_PATH= "~/playdatesdk-1.12.3";};
};
programs.vscode = {
  enable = true;
  userSettings = {
    "git.enableCommitSigning" = true;
    "editor.cursorSmoothCaretAnimation" = true;
    "git.enableSmartCommit" = true;
    "git.confirmSync" = false;
    "git.autofetch" = true;
    "files.eol" = ""; # Do not end files with a newline.
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.productIconTheme" = "material-product-icons";
    "editor.formatOnSave" = true;
    "terminal.integrated.fontFamily" = "Source Code Pro";
    "terminal.integrated.fontSize" = 12;
    "terminal.integrated.minimumContrastRatio" = 1;
    "editor.formatOnPaste" = true;
    "terminal.integrated.allowChords" = false;
    "terminal.integrated.altClickMovesCursor" = false;
    "terminal.integrated.drawBoldTextInBrightColors" = false;
    "workbench.colorTheme" = "Shades of Purple";
    "editor.inlineSuggest.enabled" = true;
    "security.workspace.trust.enabled" = true;
    "security.workspace.trust.untrustedFiles" = "open";
    "Lua.runtime.version" = "Lua 5.4";
    "Lua.diagnostics.globals" = [ "playdate" "import" ];
    "Lua.diagnostics.disable" = [ "undefined-global" "lowercase-global" ];
    "Lua.runtime.nonstandardSymbol" = [ "+=" "-=" "*=" "/=" ];
    "Lua.workspace.library" = [ "/home/headb/playdate_sdk-1.12.3/CoreLibs" ];
    "Lua.workspace.preloadFileSize" = 1000;
    "github.copilot.enable" = {
      "*" = true;
      "yaml" = false;
      "plaintext" = true;
      "markdown" = true;
    };
  };
  mutableExtensionsDir = true;
  # https://marketplace.visualstudio.com/vscode
  extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.266.1";
      sha256="D0nwLKGojvvRuviGRI9zo4SZmpZgee7ZpHLWjUK3LWA=";
    }
    {
      name = "cmake-tools";
      publisher = "ms-vscode";
      version = "1.12.27";
      sha256 = "Q5QpVusHt0qgWwbn7Xrgk8hGh/plTx/Z4XwxISnm72s=";
    }
    {
      name="cmake";
      publisher="twxs";
      version  ="0.0.17";
      sha256="CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
    }
    {
      name = "cpptools";
      publisher = "ms-vscode";
      version = "1.13.8";
      sha256 = "Cfi96o7/6smiPnXSlUfg8fI6H+2k1MVaZnjIWqRe9Uk=";
    }
    {
      name = "copilot";
      publisher = "GitHub";
      version = "1.57.7193";
      sha256 = "DdR5RqkJWlJvAhY7Rs51GDo+blBAMYmzGaoplHn3vso=";
    }
    {
      name = "copilot-labs";
      publisher = "GitHub";
      version = "0.4.488";
      sha256 = "Vy7T8PfU/4vAgHtFb++mJCfQYVijIL183XgfOJRB0ck=";
    }
    {
      name = "shades-of-purple";
      publisher = "ahmadawais";
      version = "7.1.5";
      sha256 = "FdMCmSMB3HOrqBt111kCrqFLT0VnymEfmWiuSR/buvc=";
    }
    {
      name = "material-icon-theme";
      publisher = "PKief";
      version = "4.21.0";
      sha256 = "EwJ4zGDdEak9fBAnn5pfuAU/+ONYWzl7Q6OMyc6mcZU=";
    }
    {
      name = "material-product-icons";
      publisher = "PKief";
      version = "1.4.1";
      sha256 = "CXhnfrIMmqTXXoxtJ5VgDdZxcs7ERuGUrNHXjMQMweE=";
    }
    {
      name = "Go";
      publisher = "golang";
      version = "0.35.2";
      sha256 = "YQPKB6dtIwmghw1VnYu+9krVICV2gm7Vq1FRq7lJbto=";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "2022.11.405";
      sha256 = "01cN6PqE4g/jOWXUuWScS5qZzMmFN/70SPAVLHHsejQ=";
    }
  ];
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
