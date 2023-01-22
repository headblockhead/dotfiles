{ pkgs, ... }: {
users = {
    users = {
      root.hashedPassword = "!"; # Disable root login
      headb = {
        description = "Edward Hesketh";
        isNormalUser = true;
        extraGroups =
          [ "wheel" "networkmanager" "docker" "dialout" "transmission" ];
      };
    };
  };
}
