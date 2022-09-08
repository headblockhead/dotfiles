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

in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "headb";
  home.homeDirectory = "/home/headb";


  # Packages for this user.
  home.packages = [
    #    pkgs.google-chrome
    pkgs.chromium # Needs chromium to manage chrome extensions
    pkgs.neofetch
    pkgs.cmatrix
    pkgs.gopass
    pkgs.gh
    pkgs.go
    pkgs.vscode
    #    pkgs.vscodium # non-proprietary version of vscode  
    pkgs.gnome.gnome-terminal
    pkgs.p7zip
    pkgs.vlc
    pkgs.tinygo
    pkgs.gnumake
    pkgs.nodejs
    pkgs.oh-my-zsh
    pkgs.gopls # go language server
    pkgs.nodePackages.prettier # prettier formatter
    pkgs.nixpkgs-fmt # vscode formattings
    pkgs.gnomeExtensions.dash-to-panel
    pkgs.kdenlive
    pkgs.gimp
    pkgs.tinygo
    pkgs.spotify
  ];

  # Allow home-manager to start the X session.
  xsession.enable = true;
  xsession.windowManager.command = "…";

  # Configure installed packages
  # https://github.com/nix-community/home-manager/tree/master/modules/programs
  programs.git = {
    enable = true;
    userName = "headblockhead";
    userEmail = "headblockhead@gmail.com";
    signing = {
      key = "7B485B936DB40FD57939E2A8A5D1F48A8CDD4F44";
      gpgPath = "/run/current-system/sw/bin/gpg2";
      signByDefault = true;
    };
    extraConfig = {
       pull.rebase = false;
    };
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
      cocnvim # defined from github
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
      source /home/headb/custom.zsh-theme;
      export PATH="$GOBIN:$PATH";
      export NIXPKGS_ALLOW_UNFREE=1;
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
    };
    shellAliases = {
      q = "exit";
      p = "gopass show -c -n";
      ns = "nix-shell -p";
      code = "codium";
    };
  };
  programs.vscode = {
    enable = true;
    #    package = pkgs.vscodium;
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
      "terminal.integrated.fontFamily" = "'fontawesome'";
      "terminal.integrated.fontSize" = 16;
      "editor.formatOnPaste" = true;
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.altClickMovesCursor" = false;
      "terminal.integrated.drawBoldTextInBrightColors" = false;
      "workbench.colorTheme" = "Shades of Purple";
      "editor.inlineSuggest.enabled" = true;
      "security.workspace.trust.enabled" = true;
      "security.workspace.trust.untrustedFiles" = "open";
    };
    # https://marketplace.visualstudio.com/vscode
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.43.6621";
        sha256 = "JrD0t8wSvz8Z1j6n0wfkG6pfIjt2DNZmfAbaLdj8olQ=";
      }
      {
        name = "shades-of-purple";
        publisher = "ahmadawais";
        version = "6.13.0";
        sha256 = "DcrLeI7k1ZDX9idL8J5nk2OvtT3gW2t067nkAe9EeQY=";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "4.20.0";
        sha256 = "OfFN//lnRPouREucEJKpKfXcyCN/nnZtH5oD23B4YX0=";
      }
      {
        name = "material-product-icons";
        publisher = "PKief";
        version = "1.4.0";
        sha256 = "cPH6IgQePfhfVpiEXusAXmNo2+owZW1k+5poJyxlbz8=";
      }
      {
        name = "Go";
        publisher = "golang";
        version = "0.35.2";
        sha256 = "YQPKB6dtIwmghw1VnYu+9krVICV2gm7Vq1FRq7lJbto=";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.22.1";
        sha256 = "okR1mmwg1ZEUfP924LTa98LxCenwDZ1BIS/FLt0wo8c=";
      }
      {
        name = "python";
        publisher = "ms-python";
        version = "2022.15.12451011";
        sha256 = "zO7L2we37bbn5i/vVhNoxUgMeY5WaPVS895wK8UbT2Q=";
      }
      {
        name = "cpptools";
        publisher = "ms-vscode";
        version = "1.12.4";
        sha256 = "3DJmlyQuwj40YJKqyXfHMBnaR4KjZ5n2Rje5Cx7QRIw=";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "2022.8.3105";
        sha256 = "3MyPCTZGD6axHvMd8yi9JWjviMdflbF7WhBIA2JXXYU=";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.252.0";
        sha256 = "pXd2IjbRwYgUAGVIMLE9mQwR8mG/x0MoMfK8zVh3Mvs=";
      }
      {
        name = "auto-rename-tag";
        publisher = "formulahendry";
        version = "0.1.10";
        sha256 = "uXqWebxnDwaUVLFG6MUh4bZ7jw5d2rTHRm5NoR2n0Vs=";
      }
      {
        name = "vsliveshare";
        publisher = "MS-vsliveshare";
        version = "1.0.5705";
        sha256 = "4Tv97WqrFSk7Mtcq6vF0NnsggVj9HPKFV+GKgX15ogM=";
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
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.23";
        sha256 = "64gwwajfgniVzJqgVLK9b8PfkNG5mk1W+qewKL7Dv0Q=";
      }
    ];
  };
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "fpnmgdkabkmnadcjpehmlllkndpkmiak" # wayback archiver
      "mefhakmgclhhfbdadeojlkbllmecialg" # cat new tab page
      "ljeonhoonibcofjepiphcekbihoiaife" # shades of purple theme
      "mnjggcdmjocbbbhaepdhchncahnbgone" # youtube sponsor block
      "amaaokahonnfjjemodnpmeenfpnnbkco" # codegrepper
    ];
  };
  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    themeVariant = "dark";
    profile.nix = {
      default = true;
      visibleName = "Nix Custom";
      cursorBlinkMode = "on";
      cursorShape = "ibeam";
      font = null;
      allowBold = true;
      scrollOnOutput = true;
      showScrollbar = false;
      scrollbackLines = 10000;
      customCommand = null;
      loginShell = false;
      backspaceBinding = "ascii-delete";
      boldIsBright = false;
      deleteBinding = "delete-sequence";
      audibleBell = false;
      transparencyPercent = 50;
    };
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
