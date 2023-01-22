{ pkgs, ... }: {
programs.fzf = {
  enable = true;
  enableZshIntegration = true;
  defaultOptions =
    [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
};
}
