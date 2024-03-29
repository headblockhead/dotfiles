{ pkgs, ... }:
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
    #    python39
    PlaydateSimulator # Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
    asciinema
    awscli2
    bat
    cargo
    ccls
    cmake
    cmatrix
    ec2-ami-tools
    flyctl
    gcc
    gcc-arm-embedded
    gnumake
    go
    gopass
    gopls
    hugo
    inetutils
    killall
    lm_sensors
    lua5_4
    minicom
    neofetch
    ngrok
    nixfmt
    nmap
    nodePackages.aws-cdk
    nodejs
    p7zip
    pdc # PlayDateCompiler - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
    pdutil # PlayDateUtility - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
    pico-sdk
    picotool
    platformio
    playdatemirror
    rustc
    templ
    tinygo
    tmux
    unityhub
    wireguard-tools
    wireshark
    xc # Not in nixpkgs, overlayed by github:joerdav/xc. See flake.nix.
  ];
}
