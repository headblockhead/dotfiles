{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
  vlc
  spotify
  thunderbird
  libreoffice
  audacity
  ];
}
