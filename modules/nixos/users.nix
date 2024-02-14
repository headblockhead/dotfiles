{
  users.users = {
    root.hashedPassword = "!"; # Disable root login
    headb = {
      description = "Edward Hesketh";
      isNormalUser = true;
      extraGroups =
        [ "wheel" "adbusers" "dialout" "transmission" "docker" ];
    };
  };
}
