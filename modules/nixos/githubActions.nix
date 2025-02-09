{ config, ... }:
{
  age.secrets.github-actions-token.file = ../../secrets/github-actions-token.age;
  services.github-runners = {
    slab-firmware = {
      enable = true;
      ephemeral = true;
      url = "https://github.com/headblockhead/slab-firmware";
      tokenFile = config.age.secrets.github-actions-token.path;
    };
  };
}
