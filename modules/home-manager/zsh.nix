{ ... }: {
  programs.zsh = {
    enable = true;
    initExtra = ''
      export ZSH_HIGHLIGHT_STYLES[comment]=fg=245,bold
    '';
  };
}
