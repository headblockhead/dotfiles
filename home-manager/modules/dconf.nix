{ pkgs,nixos-artwork, ... }: {
  home.packages = with pkgs; [
    gnome.dconf-editor
    ];
dconf = {
  enable = true;
  settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file://${pkgs.nixos-artwork.wallpapers.nineish.gnomeFilePath}";
      picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}";
    };
    "org/gnome/deja-dup" = {
      periodic = true;
      periodic-period = 1;
      delete-after = 0;
    };
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      clock-format = "24h";
      color-scheme = "prefer-dark"; # Enable dark mode on GNOME
    };
    "org/gnome/nautilus/compression" = { default-compression-format = "7z"; };
    "org/gnome/nautilus/icon-view" = { default-zoom-level = "medium"; };
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
      use-tree-view = true;
      default-column-order = [
        "name"
        "size"
        "type"
        "owner"
        "group"
        "permissions"
        "mime_type"
        "where"
        "date_modified"
        "date_modified_with_time"
        "date_accessed"
        "date_created"
        "recency"
        "starred"
      ];
      default-visible-columns = [ "name" "size" "date_modified" ];
    };
  };
};
}
