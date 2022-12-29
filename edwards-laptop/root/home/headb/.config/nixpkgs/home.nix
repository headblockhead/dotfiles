{ config, pkgs, ... }:

with import <nixpkgs> { };
let
  pluginGit = owner: repo: ref: sha: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${repo}";
    version = ref;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = ref;
      sha256 = sha;
    };
  };
  # https://github.com/NixOS/nixpkgs/commits/cf7f4393f3f953faf5765c7a0168c6710baa1423/pkgs/development/tools/parsing/tree-sitter
  treesitterRevisionPkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/cf7f4393f3f953faf5765c7a0168c6710baa1423.tar.gz") { };
  treesitter-grammars = treesitterRevisionPkgs.tree-sitter.allGrammars;
  nvim-treesitter-with-plugins = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: treesitter-grammars)).overrideAttrs (old: {
      version = "2022-08-31";
      src = pkgs.fetchFromGitHub {
          owner = "nvim-treesitter";
          repo = "nvim-treesitter";
          rev = "4cccb6f494eb255b32a290d37c35ca12584c74d0";
          sha256 = "XtZAXaYEMAvp6VYNRth6Y64UtKoZt3a3q8l4kSxkZQA=";
      };
    });
  my-python-packages = python-packages:
    with python-packages; [
      pandas
      requests
      pyautogui
    ];
  python-with-pyautogui = python3.withPackages my-python-packages;
  unityhub = callPackage ./unityhub.nix {};
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "headb";
  home.homeDirectory = "/home/headb";
  home.enableNixpkgsReleaseCheck = true;

  # Don't show home-manager news
  news.display = "silent";

  # Packages for this user.
  home.packages = [
    python-with-pyautogui # Defined above
    unityhub # Game-making tool - Launcher for Unity. defined above in unityhub.nix - nixpkgs is outdated https://github.com/huantianad/nixos-config/blob/main/packages/unityhub.nix
    pkgs.obinskit # Annepro2 configurator
    pkgs.cmake # C Makefile creator.
    pkgs.silver-searcher # AG - used for vim.
    pkgs.ccls # C langauge server.
    pkgs.tinygo # Go programming language complier but for small places
    pkgs.gnomeExtensions.appindicator # When apps 'minimise to tray' this is where they go
    pkgs.sumneko-lua-language-server # Lua language server for vim.
    pkgs.lua5_4 # Lua language
    pkgs.remmina # Remote desktop application.
    pkgs.platformio
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
    pkgs.gnome.gnome-terminal # Customisable terminal - not in the default installation of gnome
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
  ];

  # Configure installed packages
  # https://github.com/nix-community/home-manager/tree/master/modules/programs

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
    platformTheme = "gtk";
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark"; # Enable dark mode for GTK2
    };
    iconTheme = {
      name = "Adwaita";
    };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = \"true\"";
    gtk3.bookmarks = [ "file:///home/headb/OneDrive" ]; # Set nautilus bookmarks
    gtk3.extraConfig = {"gtk-application-prefer-dark-theme" = "true";};
    gtk4.extraConfig = {"gtk-application-prefer-dark-theme" = "true";};
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
    "org/gnome/nautilus/compression" = {
      default-compression-format = "7z";
    };
    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "medium";
    };
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
      use-tree-view = true;
      default-column-order = [ "name" "size" "type" "owner" "group" "permissions" "mime_type" "where" "date_modified" "date_modified_with_time" "date_accessed" "date_created" "recency" "starred" ];
      default-visible-columns = ["name" "size" "date_modified"];
    };
   };
 };
 programs.fzf = {
   enable = true;
   enableZshIntegration = true;
   defaultOptions = [
     "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
   ];
 };
  programs.go = {
    enable = true;
    goBin = "go/bin";
    goPath = "go";
    packages = {
  "github.com/go-delve/delve/cmd/dlv" = pkgs.fetchFromGitHub {owner = "go-delve";repo = "delve";rev="master";sha256="/26wOIhMaI8FzLfKQq7kV8WcL1F9/ELNRA/9wfy/x8g=";};
  "github.com/sago35/tinygo-edit" = pkgs.fetchFromGitHub {owner = "sago35";repo = "tinygo-edit";rev="master";sha256="KgC/ReCjZlvnBrQv5vhGvG+7+lV7fd723rQtuV9ezYI=";};
};
};
programs.gh = {
  enable = true;
  settings = {
  git_protocol = "ssh";
  prompt = "enabled";
  editor="";
  pager="";
  http_unix_socket="";
  browser="";
};
};
  programs.git = {
    enable = true;
    userName = "Edward Hesketh";
    userEmail = "headblockhead@gmail.com";
    difftastic = {
      enable = true;
      background = "dark";
      display="inline";
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
    plugins = with pkgs.vimPlugins; [
      # Theming plugins
      vim-airline
      vim-airline-themes
      #(pluginGit "yassinebridi" "vim-purpura" "2398344cb16af941a9057e6b0cf4247ce1abb5de" "KhacybPPzplSs6oyJtKSkgQ3JFxOjLSqvueafkYRPSw="); # Removed - Not tree-sitter compatible :(
      (pluginGit "Mofiqul" "dracula.nvim" "55f24e76a978c73c63d22951b0700823f21253b7" "YwcbSj+121/QaEIAqqG4EvCpCYj3VzgCE8Ndl1ABbFI=")
      # Everything else
        # Metal syntax highlighting.
        (pluginGit "tklebanoff" "metal-vim" "6970494a5490a17033650849f0a1ad07506cef2e" "14i8q9ikp3v4q7mpid9ir1azfqfm7fbksc65cpp51424clnqcapl")
        # Add fuzzy searching (Ctrl-P to search file names, space-p to search content).
        fzf-vim
        # Maintain last location in files.
        vim-lastplace
        # Syntax highlighting for Nix files.
        vim-nix
        # Colour scheme.
        # Use :TSHighlightCapturesUnderCursor to see the syntax under cursor.
        (pluginGit "nvim-treesitter" "playground" "e6a0bfaf9b5e36e3a327a1ae9a44a989eae472cf" "wst6YwtTJbR65+jijSSgsS9Isv1/vO9uAjuoUg6tVQc=")
        # Go test coverage highlighting.
        (pluginGit "rafaelsq" "nvim-goc.lua" "7d23d820feeb30c6346b8a4f159466ee77e855fd" "1b9ri5s4mcs0k539kfhf5zd3fajcr7d4lc0216pbjq2bvg8987wn")
        # General test coverage highlighting.
        (pluginGit "ruanyl" "coverage.vim" "1d4cd01e1e99d567b640004a8122be8105046921" "1vr6ylppwd61rj0l7m6xb0scrld91wgqm0bvnxs54b20vjbqcsap")
        # Grep plugin to improve grep UX.
        (pluginGit "dkprice" "vim-easygrep" "d0c36a77cc63c22648e792796b1815b44164653a" "0y2p5mz0d5fhg6n68lhfhl8p4mlwkb82q337c22djs4w5zyzggbc")
        # Templ highlighting.
        (pluginGit "Joe-Davidson1802" "templ.vim" "2d1ca014c360a46aade54fc9b94f065f1deb501a" "1bc3p0i3jsv7cbhrsxffnmf9j3zxzg6gz694bzb5d3jir2fysn4h")
        # Add function signatures to autocomplete.
        (pluginGit "ray-x" "lsp_signature.nvim" "e65a63858771db3f086c8d904ff5f80705fd962b" "17qxn2ldvh1gas3i55vigqsz4mm7sxfl721v7lix9xs9bqgm73n1")
        # Configure autocomplete.
        (pluginGit "hrsh7th" "nvim-cmp" "983453e32cb35533a119725883c04436d16c0120" "0649n476jd6dqd79fmywmigz19sb0s344ablwr25gr23fp46hzaz")
        # Configure autocomplete.
        (pluginGit "neovim" "nvim-lspconfig" "99596a8cabb050c6eab2c049e9acde48f42aafa4" "qU9D2bGRS6gDIxY8pgjwTVEwDTa8GXHUUQkXk9pBK/U=")
        # Snippets manager.
        (pluginGit "L3MON4D3" "LuaSnip" "e687d78fc95a7c04b0762d29cf36c789a6d94eda" "11a9b744cgr3w2nvnpq1bjblqp36klwda33r2xyhcvhzdcz0h53v")
        # Add snippets to the autocomplete.
        (pluginGit "saadparwaiz1" "cmp_luasnip" "a9de941bcbda508d0a45d28ae366bb3f08db2e36" "0mh7gimav9p6cgv4j43l034dknz8szsnmrz49b2ra04yk9ihk1zj")
        # Show diagnostic errors inline.
        (pluginGit "folke" "trouble.nvim" "929315ea5f146f1ce0e784c76c943ece6f36d786" "07nyhg5mmy1fhf6v4480wb8gq3dh7g9fz9l5ksv4v94sdp5pgzvz")
        # Go debugger.
        (pluginGit "sebdah" "vim-delve" "5c8809d9c080fd00cc82b4c31900d1bc13733571" "01nlzfwfmpvp0q09h1k1j5z82i925hrl9cg9n6gbmcdqsvdrzy55")
        # Replacement for netrw.
        (pluginGit "nvim-tree" "nvim-web-devicons" "3b1b794bc17b7ac3df3ae471f1c18f18d1a0f958" "hxujmUwNtDAXd6JCxBpvPpOzEENQSOYepS7fwmbZufs=")
        (pluginGit "nvim-tree" "nvim-tree.lua" "1837751efb5fcfc584cb0ee900f09ff911cd6c0b" "emoQbOwwZOCV4F4/vSgcfMmnJFXvxgEAxqCwZyY1zpU=")
        # \c to toggle commenting out a line.
        nerdcommenter #preservim/nerdcommenter
        # Work out tabs vs spaces etc. automatically.
        vim-sleuth #tpope/vim-sleuth
        # Change surrounding characters, e.g. cs"' to change from double to single quotes.
        vim-surround #tpope/vim-surround
        vim-test #janko/vim-test
        vim-visual-multi #mg979/vim-visual-multi
        cmp-nvim-lsp
        nvim-treesitter-with-plugins #github.com/nvim-treesitter/nvim-treesitter
        targets-vim # https://github.com/wellle/targets.vim
      ];
      extraConfig = "lua require('init')";
#      " Disable mouse input reading.
#      set mouse=
#      " Don't spill gopass secrets.
#      au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
#    '';
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" "git" ];
    };
    initExtra = ''
      source ~/custom.zsh-theme
      export NIXPKGS_ALLOW_UNFREE=1
      export ZSH_HIGHLIGHT_STYLES[comment]=fg=245,bold
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
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
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
    localVariables = {
      EDITOR = "nvim";
      GOPATH = "/home/$USER/go";
      GOBIN = "/home/$USER/go/bin";
      PATH = "$GOBIN:$PATH";
    };
    shellAliases = {
      q = "exit";
      p = "gopass show -c -n";
      ns = "nix-shell -p";
    };
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
    mutableExtensionsDir = false; # Helps to run platformio-ide
    # https://marketplace.visualstudio.com/vscode
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-pull-request-github";
        publisher = "github";
        version = "0.54.1";
        sha256 = "AhsKTjIhyhGW9KcqAhWAzYAOv/wuQvNFKWlPmiK7hUQ=";
      }
      {
        name = "platformio-ide";
        publisher = "platformio";
        version = "2.5.5";
        sha256 = "hg4Ru+mMJBXPlPPluhh7kL/ThWt2fwb2AxgHo4K0LgA=";
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
        sha256="Vy7T8PfU/4vAgHtFb++mJCfQYVijIL183XgfOJRB0ck=";
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
        name = "lua";
        publisher = "sumneko";
        version = "3.6.4";
        sha256 = "/JZqls/+aBzGuQPp+LuderM7/H932U9gYA6p5IcSSdA="; 
      }
#      {
#        name = "cpptools";
#        publisher = "ms-vscode";
#        version = "1.13.3";
#        sha256 = "BxBOFlkRrk+QOba5BaNiRnkfJlHMMU61bBC6g4WcZmQ=";
#      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "2022.11.405";
        sha256 = "01cN6PqE4g/jOWXUuWScS5qZzMmFN/70SPAVLHHsejQ=";
      }
      {
        name = "auto-rename-tag";
        publisher = "formulahendry";
        version = "0.1.10";
        sha256 = "uXqWebxnDwaUVLFG6MUh4bZ7jw5d2rTHRm5NoR2n0Vs=";
      }
      {
        name = "path-intellisense";
        publisher = "christian-kohler";
        version = "2.8.1";
        sha256 = "lTKzMphkGgOG2XWqz3TW2G9sISBc/kG7oXqcIH8l+Mg=";
      }
      {
        name = "indent-rainbow";
        publisher = "oderwat";
        version = "8.3.1";
        sha256 = "dOicya0B2sriTcDSdCyhtp0Mcx5b6TUaFKVb0YU3jUc=";
      }
      {
        name = "vscode-todo-highlight";
        publisher = "wayou";
        version = "1.0.5";
        sha256 = "CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok=";
      }
      {
        name = "rainbow-brackets";
        publisher = "2gua";
        version = "0.0.6";
        sha256 = "TVBvF/5KQVvWX1uHwZDlmvwGjOO5/lXbgVzB26U8rNQ=";
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
