{ config, pkgs, inputs, ...}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  services.minecraft-servers = {
    enable = true;
    openFirewall = true;
    eula=true;
    servers.barkup = {
      enable=true;
    package = pkgs.quiltServers.quilt-1_20_1;
  symlinks = {
    mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
      CreateFabric = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Xbc0uyRg/versions/qlA1WuOK/create-fabric-0.5.1-d-build.1161%2Bmc1.20.1.jar"; sha256="c7mBDzuY0Xjqnj0QG46gAPDD92Kcn9Ol5sAXdn7LRhQ="; };
      CreateSteamNRails = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/ZzjhlDgM/versions/E3cqlz5f/Steam_Rails-1.5.2%2Bforge-mc1.20.1.jar"; sha256="bWC5Dcustj7uXUMHUcfe+2I6tvtgfKeSzr0xh7mlJl0="; };
      Collective = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/TobnIU5c/collective-1.20.1-6.66.jar";
        sha256 = "032d7vm5yqlnr2ag1hiypmv18d2zimgh617hr7i7kvb8rznj35ig"; 
      };
      FerriteCore = pkgs.fetchurl { url= "https://cdn.modrinth.com/data/uXXizFIs/versions/FCnCG6PS/ferritecore-6.0.0-fabric.jar"; sha256="778dTfKoliG7jXCQ4ElmeVBH2xZRP+9nOlKaB9/2av4="; };
      Krypton = pkgs.fetchurl { url="https://cdn.modrinth.com/data/fQEb0iXm/versions/jiDwS0W1/krypton-0.2.3.jar"; sha256="aa0YECBs4SGBsbCDZA8ETn4lB4HDbJbGVerDYgkFdpg="; };
      StackDeobfuscator = pkgs.fetchurl { url="https://cdn.modrinth.com/data/NusMqsjF/versions/BKQIsrwC/StackDeobfuscatorFabric-1.4.1%2B03a1fe4.jar"; sha256="3rTaxwj3IrUPkEL2WSybfl9rS1fOdH6Ps5vk3KrECTg="; };
      NotEnoughCrashes = pkgs.fetchurl { url="https://cdn.modrinth.com/data/yM94ont6/versions/dUMsjI9u/notenoughcrashes-4.4.6%2B1.20.1-fabric.jar"; sha256="j1AJxJF/4sfYSJHie5R10c8J12BWwCgFRZY6Q6g9gKw="; };
      QuiltedFabricAPI = pkgs.fetchurl { url="https://cdn.modrinth.com/data/qvIfYCYJ/versions/GjvWb8WQ/qfapi-7.4.0_qsl-6.1.2_fapi-0.90.0_mc-1.20.1.jar"; sha256="9Gq5U12jUuSOc9F2h8vdLt4JeGIo16v32ZRp26PAJ3A="; };
      Spark = pkgs.fetchurl { url="https://cdn.modrinth.com/data/l6YH9Als/versions/XGW2fviP/spark-1.10.53-fabric.jar"; sha256="AMA05oT6RHG0FTncKajTnMbyLrKbL6QjiV78l4o5HS0="; };
      Lithium = pkgs.fetchurl { url="https://cdn.modrinth.com/data/gvQqBUqZ/versions/ZSNsJrPI/lithium-fabric-mc1.20.1-0.11.2.jar"; sha256="oMWVNV1oDgyHv46uuv7f9pANTncajWiU7m0tQ3Tejfk="; };
    });
  };
};
};
}
