{ pkgs, ... }: {
  home.packages = with pkgs; [
    xc # Not in nixpkgs, overlayed by github:joerdav/xc. See flake.nix.
    wireguard-tools
    tinygo
    lua5_4
    bat
    cargo
    rustc
    nixfmt
    ngrok
    awscli2
    asciinema
    neofetch
    cmatrix
    gopass
    p7zip
    hugo
    nodejs
    nodePackages.aws-cdk
    ec2-ami-tools
    wireshark
    nmap
    killall
    flyctl
    platformio
    tmux
    lm_sensors
    inetutils
  ];
  services.udev.packages = [ pkgs.platformio-core.udev ];
}
