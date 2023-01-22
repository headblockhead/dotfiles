{ pkgs, ... }: {
dconf = {
  enable = true;
  settings = {
    "org/gnome/deja-dup" = {
      periodic = true;
      periodic-period = 1;
      delete-after = 0;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
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