{ pkgs, ... }: {
  home.packages = with pkgs; [
  oh-my-zsh
    zsh
  ];
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
  sessionVariables = {};
};
}