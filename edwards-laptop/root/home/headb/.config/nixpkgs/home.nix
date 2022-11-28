{ config, pkgs, ... }:

with import <nixpkgs> { };
let
  vim-purpura = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-purpura";
    version = "2398344cb16af941a9057e6b0cf4247ce1abb5de";

    src = fetchFromGitHub {
      owner = "yassinebridi";
      repo = "vim-purpura";
      rev = "2398344cb16af941a9057e6b0cf4247ce1abb5de";
      sha256 = "KhacybPPzplSs6oyJtKSkgQ3JFxOjLSqvueafkYRPSw=";
    };
  };
  lspSignatureNvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "lsp_signature.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "lsp_signature.nvim";
      rev = "f7c308e99697317ea572c6d6bafe6d4be91ee164";
      sha256 = "0s48bamqwhixlzlyn431z7k3bhp0y2mx16d36g66c9ccgrs5ifmm";
    };
  };
  cocnvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "coc.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "neoclide";
      repo = "coc.nvim";
      rev = "v0.0.82";
      sha256 = "TIkx/Sp9jnRd+3jokab91S5Mb3JV8yyz3wy7+UAd0A0=";
    };
  };
  my-python-packages = python-packages:
    with python-packages; [
      pandas
      requests
      pyautogui
    ];
  python-with-pyautogui = python3.withPackages my-python-packages;
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "headb";
  home.homeDirectory = "/home/headb";
#  home.enableNixpkgsReleaseCheck = true;

  # Don't show home-manager news
  news.display = "silent";

  # Allow ObinsKit to use outdated packages.
  nixpkgs.config.permittedInsecurePackages = [ "electron-13.6.9" ];

  # Packages for this user.
  home.packages = [
    python-with-pyautogui # Defined above
    pkgs.gnomeExtensions.appindicator # When apps 'minimise to tray' this is where they go
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
    pkgs.minecraft # Block Game
    pkgs.cura # 3D Printing Slicer
    pkgs.unityhub # Game-making tool - Launcher for Unity
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
    pkgs.tinygo # Go programming language complier but for small places
    pkgs.gnumake # Runs Makefiles
    pkgs.nodejs # Javascript stuff
    pkgs.oh-my-zsh # ZSH customiser
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
      vim-airline
      vim-airline-themes
      vim-fugitive
      vim-prettier
      vim-purpura # theme defined from github
      vim-lastplace
      vim-nix
      vim-go
      cocnvim # plugin defined from github
    ];
    extraConfig = ''
      " Dont try to be compatible with vi - be iMproved
      set nocompatible
      " Dont check filetype
      filetype off
      " Theming - for the looks only.
      colorscheme purpura
      set background=dark
      set termguicolors
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      let g:netrw_banner = 0
      let g:netrw_liststyle = 3
      let g:airline_theme='purpura'
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#formatter = 'unique_tail'
      hi Normal guibg=NONE ctermbg=NONE
      hi LineNr ctermbg=NONE guibg=NONE guifg=NONE 
      hi EndOfBuffer ctermbg=NONE guibg=NONE
      hi SignColumn  ctermbg=NONE guibg=NONE
      " Claim space in the column for when there are errors in the future
      set signcolumn=yes
      " Disable mouse input reading.
      set mouse=
      " Add line numbers.
      set nu
      " Syntax highlighting.
      syntax enable
      " Don't spill gopass secrets.
      au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
      " Set an easier to reach leader.
      let mapleader = ","
      " Change how vim represents characters on the screen.
      set encoding=utf-8
      set fileencoding=utf-8
      " Use leader + f to format the document.
      xmap <leader>f  <Plug>(coc-format)
      nmap <leader>f  <Plug>(coc-format)
    '';
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
      "files.eol" = "\n";
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
      "playdate.source" = "source";
      "playdate.output" = "builds/out.pdx";
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
    # https://marketplace.visualstudio.com/vscode
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
        name = "cpptools";
        publisher = "ms-vscode";
        version = "1.13.3";
        sha256 = "BxBOFlkRrk+QOba5BaNiRnkfJlHMMU61bBC6g4WcZmQ=";
      }
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