{ config, ... }:
{
  age.secrets.github-actions-token.file = ../../secrets/github-actions-token.age;
  services.github-runners = {
    squirrel = {
      enable = true;
      ephemeral = true;
      url = "https://github.com/headblockhead/squirrel";
      tokenFile = config.age.secrets.github-actions-token.path;
    };
    slab-firmware = {
      enable = true;
      ephemeral = true;
      url = "https://github.com/headblockhead/slab-firmware";
      tokenFile = config.age.secrets.github-actions-token.path;
    };
  };
}
