{ pkgs, lib, ... }: {

  systemd.tmpfiles.rules = [
    "c+ /var/lib/AccountsService/icons/headb - - - - ${./headb.png}"
  ];
  programs.dconf =
    {
      enable = true;
      profiles = {
        user.databases = [
          {
            settings = {
              "org/gnome/shell" = {
                disabled-extentions = [
                  "apps-menu@gnome-shell-extensions.gcampax.github.com"
                  "native-window-placement@gnome-shell-extensions.gcampax.github.com"
                  "drive-menu@gnome-shell-extensions.gcampax.github.com"
                  "user-theme@gnome-shell-extensions.gcampax.github.com"
                  "window-list@gnome-shell-extensions.gcampax.github.com"
                  "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
                  "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
                  "light-style@gnome-shell-extensions.gcampax.github.com"
                  "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
                  "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
                ];
                enabled-extensions = [
                  "appindicatorsupport@rgcjonas.gmail.com"
                  "system-monitor@gnome-shell-extensions.gcampax.github.com"
                  "display-brightness-ddcutil@themightydeity.github.com"
                  "unblank@sun.wxg@gmail.com"
                ];
              };
              "org/gnome/shell/extensions/display-brightness-ddcutil" = {
                show-all-slider = false;
                show-value-label = false;
                show-display-name = false;
                show-osd = false;
                button-location = lib.gvariant.mkUint32 1;
                hide-system-indicator = false;
                position-system-indicator = lib.gvariant.mkDouble 2.0;
                position-system-menu = lib.gvariant.mkDouble 3.0;
                step-change-keyboard = lib.gvariant.mkDouble 10.0;
                allow-zero-brightness = true;
                ddcutil-binary-path = "${pkgs.ddcutil}/bin/ddcutil";
              };
              "org/gnome/desktop/session" = {
                idle-delay = lib.gvariant.mkUint32 0;
              };
              "org/gnome/settings-daemon/plugins/power" = {
                power-button-action = "interactive";
                sleep-inactive-ac-type = "nothing";
                sleep-inactive-battery-timeout = lib.gvariant.mkInt32 1800;
              };
              "org/gnome/mutter" = {
                "experimental-features" = [ "scale-monitor-framebuffer" ];
                #"experimental-features" = [ "x11-randr-fractional-scaling" ];
              };
              "org/gnome/desktop/background" = {
                "picture-uri" = "file://${pkgs.nixos-artwork.wallpapers.nineish.gnomeFilePath}";
                "picture-uri-dark" = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}";
              };
              "org/gnome/desktop/input-sources" = {
                xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" "compose:rctrl" ];
              };
              "org/gnome/nautilus/list-view" = {
                default-zoom-level = "small";
                use-tree-view = false;
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
              "org/gnome/settings-daemon/plugins/color" = {
                "night-light-enabled" = true;
                "night-light-schedule-automatic" = true;
                "night-light-temperature" = lib.gvariant.mkUint32 2700;
              };
              "org/gnome/terminal/legacy" = {
                "default-show-menubar" = false;
                "schema-version" = lib.gvariant.mkUint32 3;
                "theme-variant" = "default";
              };
              "org/gnome/terminal/legacy/keybindings" = {
                "prev-tab" = "<Primary><Shift>Home";
                "next-tab" = "<Primary><Shift>End";
              };
              "org/gnome/terminal/legacy/profiles:" = {
                "default" = "5ddfe964-7ee6-4131-b449-26bdd97518f7";
                "list" = [ "5ddfe964-7ee6-4131-b449-26bdd97518f7" ];
              };
              "org/gnome/terminal/legacy/profiles:/:5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
                "audible-bell" = true;
                "background-color" = "#000000";
                "backspace-binding" = "ascii-delete";
                "bold-color-same-as-fg" = true;
                "cursor-blink-mode" = "system";
                "cursor-colors-set" = false;
                "cursor-shape" = "block";
                "delete-binding" = "delete-sequence";
                "font" = "SauceCodePro Nerd Font 12";
                "foreground-color" = "#FFFFFF";
                "highlight-colors-set" = false;
                "login-shell" = false;
                "palette" = [ "#000000" "#aa0000" "#00aa00" "#aa5500" "#0000aa" "#aa00aa" "#00aaaa" "#aaaaaa" "#555555" "#ff5555" "#55ff55" "#ffff55" "#5555ff" "#ff55ff" "#55ffff" "#ffffff" ];
                "scrollback-lines" = lib.gvariant.mkInt32 10000;
                "scrollbar-policy" = "never";
                "scroll-on-output" = false;
                "use-custom-command" = false;
                "use-system-font" = false;
                "use-theme-colors" = false;
                "visible-name" = "NixOS";
              };
              "org/gnome/desktop/interface" = {
                "clock-format" = "24h";
                "gtk-theme" = "Adwaita-dark";
                "color-scheme" = "prefer-dark";
                "clock-show-weekday" = true;
                "show-battery-percentage" = true;
                "clock-show-seconds" = true;
              };
              "org/gnome/desktop/privacy" = {
                "old-files-age" = lib.gvariant.mkInt32 7;
                "recent-files-max-age" = lib.gvariant.mkInt32 7;
                "remove-old-temp-files" = true;
                "remove-old-trash-files" = true;
              };
              "org/gnome/settings-daemon/plugins/media-keys" = {
                "custom-keybindings" = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                "name" = "Terminal";
                "command" = "gnome-terminal";
                "binding" = "<Control><Alt>t";
              };
              "org/gnome/nautilus/preferences" = {
                "default-folder-viewer" = "list-view";
              };
              "org/gnome/nautilus/compression" = {
                "default-compression-method" = "7z";
              };
              "org/gnome/nautilus/icon-view" = {
                "default-zoom-level" = "medium";
              };
            };
          }
        ];
      };
    };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
      };
    };
    desktopManager.gnome = {
      enable = true;
    };
  };

  # Touchpad/touchscreen support.
  services.libinput.enable = true;

  # Exclude certain xserver packages.
  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.next-up # Next calendar event
    gnomeExtensions.appindicator # Tray icons
    gnomeExtensions.unblank
    gnome.gnome-calendar
  ];

  # GNOME terminal - replaces the console.
  programs.gnome-terminal.enable = true;

  services.gnome.gnome-keyring.enable = lib.mkForce
    false; # Dont mess with SSH_AUTH_SOCK

  # Exclude certain default gnome apps.
  # See https://github.com/NixOS/nixpkgs/blob/127579d6f40593f9b9b461b17769c6c2793a053d/nixos/modules/services/x11/desktop-managers/gnome.nix#L468 for a list of apps.
  environment.gnome.excludePackages = (with pkgs.gnome; [
    pkgs.gnome-tour # Tour
    # gnome-logs # Logs
    yelp # Help
    gnome-maps # Maps
    gnome-music # Music
    geary # Geary (Mail)
    epiphany # Web
    gnome-characters # Characters
    pkgs.gnome-console # Console - basic terminal emulator
    totem # Videos
    pkgs.gnome-photos # Photos
    gnome-contacts # Contacts
    gnome-maps # Maps
    gnome-music # Music
    gnome-weather # Weather
    pkgs.gnome-connections # Connections
  ]);

  # Add udev rules.
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gnome";
  };

  # Symlink fonts into /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Install fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];

}
