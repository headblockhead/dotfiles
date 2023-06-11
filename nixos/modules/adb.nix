{pkgs,...}:
{
programs.adb.enable = true;
  users.users.headb.extraGroups = ["adbusers"];
}
