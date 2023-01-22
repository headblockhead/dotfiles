{ pkgs, ... }: {
  home.packages = with pkgs; [
 gnome.gnome-terminal 
  ];
programs.gnome-terminal = {
  enable = true;
  showMenubar = false;
  profile = {
    "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
      default = true;
      visibleName = "Nix Custom";
      cursorShape = "block";
      font = "SauceCodePro Nerd Font 12"; # Size: 12
      showScrollbar = false;
      colors = {
        backgroundColor = "#000000";
        foregroundColor = "#ffffff";
        palette = [
          "#000000"
          "#aa0000"
          "#00aa00"
          "#aa5500"
          "#0000aa"
          "#aa00aa"
          "#00aaaa"
          "#aaaaaa"
          "#555555"
          "#ff5555"
          "#55ff55"
          "#ffff55"
          "#5555ff"
          "#ff55ff"
          "#55ffff"
          "#ffffff"
        ];
      };
    };
  };
};
}
