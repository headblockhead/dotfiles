{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.neovim
    pkgs.git
  ];
}
