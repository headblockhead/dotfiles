{ config, pkgs, ...}:
{
  services.minecraft-servers.servers.barkup = {
    enable = true;
    package = pkgs.quiltServers.quilt-1_20_1-0_9_1;
  symlinks = {
    mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
      CreateFabric = fetchurl { url = "https://cdn.modrinth.com/data/Xbc0uyRg/versions/qlA1WuOK/create-fabric-0.5.1-d-build.1161%2Bmc1.20.1.jar"; sha256=""; };
      CreateSteamNRails = fetchurl { url = "https://cdn.modrinth.com/data/ZzjhlDgM/versions/E3cqlz5f/Steam_Rails-1.5.2%2Bforge-mc1.20.1.jar"; sha256=""; };
      Collective = fetchurl { url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/TobnIU5c/collective-1.20.1-6.66.jar"; sha256=""; };
      FerriteCore = fetchurl { url= "https://cdn.modrinth.com/data/uXXizFIs/versions/FCnCG6PS/ferritecore-6.0.0-fabric.jar"; sha256=""; };
      Krypton = fetchurl { url="https://cdn.modrinth.com/data/fQEb0iXm/versions/jiDwS0W1/krypton-0.2.3.jar"; sha256=""; };
      StackDeobfuscator = fetchurl { url="https://cdn.modrinth.com/data/NusMqsjF/versions/BKQIsrwC/StackDeobfuscatorFabric-1.4.1%2B03a1fe4.jar"; sha256=""; };
      NotEnoughCrashes = fetchurl { url="https://cdn.modrinth.com/data/yM94ont6/versions/dUMsjI9u/notenoughcrashes-4.4.6%2B1.20.1-fabric.jar"; sha256=""; };
      QuiltedFabricAPI = fetchurl { url="https://cdn.modrinth.com/data/qvIfYCYJ/versions/GjvWb8WQ/qfapi-7.4.0_qsl-6.1.2_fapi-0.90.0_mc-1.20.1.jar"; sha256=""; };
      Spark = fetchurl { url="https://cdn.modrinth.com/data/l6YH9Als/versions/XGW2fviP/spark-1.10.53-fabric.jar"; sha256=""; };
      Lithium = fetchurl { url="https://cdn.modrinth.com/data/gvQqBUqZ/versions/ZSNsJrPI/lithium-fabric-mc1.20.1-0.11.2.jar"; sha256=""; };
    });
  };
};
}
