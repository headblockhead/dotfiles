{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.zsh
    pkgs.git
  ];
programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  shellInit=''
      source ~/custom.zsh-theme
  '';
  ohMyZsh = {
    enable = true;
    plugins = [ "aws" "git" ];
  };
  shellAliases = {
    q = "exit";
    p = "gopass show -c -n";
    ls = "ls --color=tty -A";
  };
};

  users.defaultUserShell = pkgs.zsh;
}
