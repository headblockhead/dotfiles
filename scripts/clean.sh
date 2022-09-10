home-manager expire-generations -1+second
sudo nix-collect-garbage -d
nix-store --gc