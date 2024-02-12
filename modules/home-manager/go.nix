{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    gopls
    templ
  ];
  programs.go = {
    enable = true;
    goBin = "go/bin";
    goPath = "go";
  };
}
