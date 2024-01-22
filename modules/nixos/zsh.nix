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
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "aws" "git" ];
    };
    shellInit = ''
      source ${../../custom.zsh-theme}
    '';
    shellAliases = {
      q = "exit";
      p = "gopass show -c -n";
      ls = "ls --color=tty -A";
    };
  };
}
