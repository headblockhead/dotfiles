{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.zsh
    pkgs.git
  ];
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.bash;
}
