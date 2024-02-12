{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    initExtra = ''
      export EDITOR='vim'
      export PATH="$GOBIN:$PATH"
      export ZSH_HIGHLIGHT_STYLES[comment]=fg=245,bold
    '';
    plugins = [
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
  };
}
