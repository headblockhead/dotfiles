{ pkgs, ... }:
{
  # Default user shell is zsh.
  users.defaultUserShell = pkgs.zsh;

  # Root user does not have zsh themes in home directory.
  users.users.root.shell = pkgs.bash;

  programs.nix-index.enableZshIntegration = true;
  programs.zsh = {
    # Enable zsh as a shell, add it to the environment.
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" "git" ];
    };
    shellInit = ''
      source ~/dotfiles/oh-my-zsh/custom.zsh-theme
    '';
    shellAliases = {
      q = "exit";
      p = "gopass show -c -n";
      ls = "ls --color=tty -A";
    };
  };
}
