{ pkgs, ... }:
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
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
    unstable.freecad-wayland
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
    nixfmt-rfc-style
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
    pulseview
    python39
    rustc
    templ
    tmux
    # unityhub
    usbutils
    wireguard-tools
    wireshark
    xc # Not in nixpkgs, overlayed by github:joerdav/xc. See flake.nix.

    neovim
    qemu

    #    (lib.hiPrio (pkgs.runCommand "nvim.desktop-hide" { } ''
    #mkdir -p "$out/share/applications"
    #cat "${neovim}/share/applications/nvim.desktop" > "$out/share/applications/nvim.desktop"
    #echo "Hidden=1" >> "$out/share/applications/nvim.desktop"
    #''))

  ];
}
