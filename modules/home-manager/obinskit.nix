{ pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [ "electron-13.6.9" ];
  home.packages = with pkgs; [
    obinskit
  ];
}
