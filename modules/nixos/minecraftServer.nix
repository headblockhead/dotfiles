{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 8192 25565 ];

  services.minecraft-servers = {
    enable = true;
    openFirewall = true;
    eula = true;
    servers.barkup = {
      enable = true;
      restart = "no";
      jvmOpts = "-Xms6144M -Xmx6144M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20";
      package = pkgs.quiltServers.quilt-1_20_1;
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          BetterFabricConsole = pkgs.fetchurl {
            url = "https://cdn-raw.modrinth.com/data/Y8o1j1Sf/versions/8YUqYot0/better-fabric-console-mc1.20.1-1.1.6.jar";
            sha256 = "Fl+bKhUwBk7Q/P3Z43g6vP51b4SyCt9QYRn631J1IOc=";
          };
          CreateFabric = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Xbc0uyRg/versions/qlA1WuOK/create-fabric-0.5.1-d-build.1161%2Bmc1.20.1.jar";
            sha256 = "c7mBDzuY0Xjqnj0QG46gAPDD92Kcn9Ol5sAXdn7LRhQ=";
          };
          CreateSteamNRails = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ZzjhlDgM/versions/E3cqlz5f/Steam_Rails-1.5.2%2Bforge-mc1.20.1.jar";
            sha256 = "bWC5Dcustj7uXUMHUcfe+2I6tvtgfKeSzr0xh7mlJl0=";
          };
          Collective = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/TobnIU5c/collective-1.20.1-6.66.jar";
            sha256 = "032d7vm5yqlnr2ag1hiypmv18d2zimgh617hr7i7kvb8rznj35ig";
          };
          BlueMap = pkgs.fetchurl {
            url = "https://mediafilez.forgecdn.net/files/4772/565/BlueMap-3.17-fabric-1.20.jar";
            sha256 = "rOsITKL30MiKeT8JYm4lnX0MtnvjAXUYIxm5nBy78dw=";
          };
          FerriteCore = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/FCnCG6PS/ferritecore-6.0.0-fabric.jar";
            sha256 = "778dTfKoliG7jXCQ4ElmeVBH2xZRP+9nOlKaB9/2av4=";
          };
          C2ME = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/VSNURh3q/versions/T5Pkyhit/c2me-fabric-mc1.20.1-0.2.0%2Balpha.11.0.jar";
            sha256 = "VQIWNH3BLLtfKc6PAt5cRPSI9eVMoqGcS/6E+b6HaiE=";
          };
          Krypton = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/jiDwS0W1/krypton-0.2.3.jar";
            sha256 = "aa0YECBs4SGBsbCDZA8ETn4lB4HDbJbGVerDYgkFdpg=";
          };
          StackDeobfuscator = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/NusMqsjF/versions/BKQIsrwC/StackDeobfuscatorFabric-1.4.1%2B03a1fe4.jar";
            sha256 = "3rTaxwj3IrUPkEL2WSybfl9rS1fOdH6Ps5vk3KrECTg=";
          };
          NotEnoughCrashes = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/yM94ont6/versions/dUMsjI9u/notenoughcrashes-4.4.6%2B1.20.1-fabric.jar";
            sha256 = "j1AJxJF/4sfYSJHie5R10c8J12BWwCgFRZY6Q6g9gKw=";
          };
          QuiltedFabricAPI = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qvIfYCYJ/versions/GjvWb8WQ/qfapi-7.4.0_qsl-6.1.2_fapi-0.90.0_mc-1.20.1.jar";
            sha256 = "9Gq5U12jUuSOc9F2h8vdLt4JeGIo16v32ZRp26PAJ3A=";
          };
          Spark = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/XGW2fviP/spark-1.10.53-fabric.jar";
            sha256 = "AMA05oT6RHG0FTncKajTnMbyLrKbL6QjiV78l4o5HS0=";
          };
          Lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/ZSNsJrPI/lithium-fabric-mc1.20.1-0.11.2.jar";
            sha256 = "oMWVNV1oDgyHv46uuv7f9pANTncajWiU7m0tQ3Tejfk=";
          };
        });
      };
    };
  };
}
