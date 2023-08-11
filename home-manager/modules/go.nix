{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    gopls
  ];
programs.go = {
  enable = true;
  goBin = "go/bin";
  goPath = "go";
  packages = {
    "github.com/go-delve/delve/cmd/dlv" = pkgs.fetchFromGitHub {
      owner = "go-delve";
      repo = "delve";
      rev = "891a1f0";
      sha256 = "mcfXMkQbVk7Z1Ovloo9Wc8HKMzefW+s+sbmCaGdK9e8=";
    };
    "github.com/sago35/tinygo-edit" = pkgs.fetchFromGitHub {
      owner = "sago35";
      repo = "tinygo-edit";
      rev = "master";
      sha256 = "KgC/ReCjZlvnBrQv5vhGvG+7+lV7fd723rQtuV9ezYI=";
    };
  };
};
}
