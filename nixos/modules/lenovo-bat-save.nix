{ pkgs, lib, ... }: {

    boot.initrd.availableKernelModules = [
        "thinkpad_acpi"
      ];
          boot.kernelPackages = pkgs.linuxPackages_latest;
          boot.kernelParams = ["intel_pstate=disable"];
  boot.extraModprobeConfig = lib.mkMerge [
    # idle audio card after one second
    "options snd_hda_intel power_save=1"
    # enable wifi power saving (keep uapsd off to maintain low latencies)
    "options iwlwifi power_save=1 uapsd_disable=1"
  ];
services.power-profiles-daemon.enable = false;
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC="schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT="schedutil";

        CPU_SCALING_MIN_FREQ_ON_AC=2000000;
        CPU_SCALING_MAX_FREQ_ON_AC=2900000;
        CPU_SCALING_MIN_FREQ_ON_BAT=1500000;
        CPU_SCALING_MAX_FREQ_ON_BAT=2000000;

        START_CHARGE_THRESH_BAT1=75;
        STOP_CHARGE_THRESH_BAT1=80;

        START_CHARGE_THRESH_BAT0=75;
        STOP_CHARGE_THRESH_BAT0=80;

        # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
        # A value of 0 disables, >=1 enables power saving (recommended: 1).
        # Default: 0 (AC), 1 (BAT)
        SOUND_POWER_SAVE_ON_AC=0;
        SOUND_POWER_SAVE_ON_BAT=1;

        # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
        # Default: on (AC), auto (BAT)
        RUNTIME_PM_ON_AC="on";
        RUNTIME_PM_ON_BAT="auto";

        # Battery feature drivers: 0=disable, 1=enable
        # Default: 1 (all)
        NATACPI_ENABLE=1;
        TPACPI_ENABLE=1;
        TPSMAPI_ENABLE=1;
      };
    };
services.upower.enable = true;
  services.udev.extraRules = lib.mkMerge [
    # autosuspend USB devices
    ''ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"''
    # autosuspend PCI devices
    ''ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"''
    # disable Ethernet Wake-on-LAN
    ''ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol d"''
  ];
}
