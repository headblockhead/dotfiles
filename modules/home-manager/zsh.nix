{ ... }: {
  programs.zsh = {
    enable = true;
    initExtra = ''
      export EDITOR='vim'
      export PATH="$GOBIN:$PATH"
      export ZSH_HIGHLIGHT_STYLES[comment]=fg=245,bold
    '';
  };
}
