{ pkgs, ... }: {
  home.packages = with pkgs; [  
    adwaita-qt
  ];
qt = {
  enable = true;
  style = { name = "adwaita-dark"; };
  platformTheme = "gtk";
};
}
