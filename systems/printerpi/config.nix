{ inputs, outputs, config, pkgs, lib, ... }:

{
  networking.hostName = "printerpi";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    cachesLocal
    distributedBuilds
    git
    firewall
    homeManager
    users
    ssh
    zsh
  ];

  services.klipper = {
    enable = true;
    logFile = "/var/log/klipper.log";
    settings = {
      printer = {
        kinematics = "cartesian";
        max_velocity = 300;
        max_accel = 3000;
        max_z_velocity = 5;
        max_z_accel = 100;
      };
      mcu = {
        serial = "/dev/serial/by-id/usb-Klipper_stm32g0b1xx_3C003B000350415339373620-if00";
      };
      display = {
        lcd_type = "st7920";
        cs_pin = "EXP1_7";
        sclk_pin = "EXP1_6";
        sid_pin = "EXP1_8";
        encoder_pins = [ "^EXP1_5" "^EXP1_3" ];
        click_pin = "^!EXP1_2";
      };
      board_pins = {
        aliases = [
          "EXP1_1=PB5"
          "EXP1_3=PA9"
          "EXP1_5=PA10"
          "EXP1_7=PB8"
          "EXP1_9=<GND>"
          "EXP1_2=PA15"
          "EXP1_4=<RST>"
          "EXP1_6=PB9"
          "EXP1_8=PD6"
          "EXP1_10=<5V>"
        ];
      };
      idle_timeout = {
        timeout = 39600; # 11 hours
      };
      "gcode_macro M601" = {
        gcode = "pause";
      };
      "menu __main __octoprint" = {
        type = "disabled";
      };
      bed_screws = {
        screw1 = [ 38 35 ];
        screw2 = [ 242 35 ];
        screw3 = [ 242 214 ];
        screw4 = [ 38 214 ];
      };
      screws_tilt_adjust = {
        screw1 = [ 69 43 ];
        screw1_name = "front left screw";
        screw2 = [ 276 43 ];
        screw2_name = "front right screw";
        screw3 = [ 276 217 ];
        screw3_name = "rear right screw";
        screw4 = [ 69 217 ];
        screw4_name = "rear left screw";
        horizontal_move_z = 10;
        speed = 50;
        screw_thread = "CW-M4";
      };
      bed_mesh = {
        speed = 150;
        horizontal_move_z = 5;
        mesh_min = [ 38 35 ];
        mesh_max = [ 242 214 ];
        probe_count = [ 3 3 ];
        move_check_distance = 10;
        split_delta_z = 0.025;
        fade_start = 1;
        fade_end = 10;
        fade_target = 0;
        mesh_pps = [ 2 2 ];
        algorithm = "bicubic";
        bicubic_tension = 0.2;
      };
      safe_z_home = {
        home_xy_position = [ 140 130 ];
        speed = 50;
        z_hop = 10;
        z_hop_speed = 5;
      };
      stepper_x = {
        step_pin = "PB13";
        dir_pin = "!PB12";
        enable_pin = "!PB14";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PC0";
        position_endstop = 0;
        position_max = 300;
        homing_speed = 50;
      };
      "tmc2209 stepper_x" = {
        uart_pin = "PC11";
        tx_pin = "PC10";
        uart_address = 0;
        run_current = 0.580;
        stealthchop_threshold = 999999;
      };
      stepper_y = {
        step_pin = "PB10";
        dir_pin = "!PB2";
        enable_pin = "!PB11";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PC1";
        position_endstop = 0;
        position_max = 250;
        homing_speed = 50;
      };
      "tmc2209 stepper_y" = {
        uart_pin = "PC11";
        tx_pin = "PC10";
        uart_address = 2;
        run_current = 0.580;
        stealthchop_threshold = 999999;
      };
      stepper_z = {
        step_pin = "PB0";
        dir_pin = "PC5";
        enable_pin = "!PB1";
        microsteps = 16;
        rotation_distance = 8;
        endstop_pin = "probe:z_virtual_endstop";
        position_min = -20;
        position_max = 300;
      };
      "tmc2209 stepper_z" = {
        uart_pin = "PC11";
        tx_pin = "PC10";
        uart_address = 1;
        run_current = 1.16;
        stealthchop_threshold = 999999;
      };
      extruder = {
        step_pin = "PB3";
        dir_pin = "PB4";
        enable_pin = "!PD1";
        microsteps = 16;
        rotation_distance = 7.49290479373;
        nozzle_diameter = 0.400;
        filament_diameter = 1.750;
        heater_pin = "PC8";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PA0";
        control = "pid";
        pid_kp = 25.118;
        pid_ki = 1.288;
        pid_kd = 122.452;
        min_temp = 0;
        max_temp = 265;
        max_extrude_only_distance = 101;
      };
      "tmc2209 extruder" = {
        uart_pin = "PC11";
        tx_pin = "PC10";
        uart_address = 3;
        run_current = 0.650;
      };
      heater_bed = {
        heater_pin = "PC9";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PC4";
        control = "pid";
        pid_kp = 73.732;
        pid_ki = 1.556;
        pid_kd = 873.719;
        min_temp = 0;
        max_temp = 110;
      };
      "heater_fan heatbreak_cooling_fan" = {
        pin = "PC6";
      };
      "controller_fan controller_fan" = {
        pin = "PB15";
      };
      fan = {
        pin = "PC7";
      };
      bltouch = {
        sensor_pin = "^PC2";
        control_pin = "PA1";
        x_offset = -51;
        y_offset = -13;
        z_offset = 0.440;
        samples = 2;
        pin_move_time = 0.4;
      };
      "output_pin buzzer" = {
        pin = "EXP1_1";
        pwm = true;
        value = 0;
        shutdown_value = 0;
        cycle_time = 0.001;
      };
      "filament_switch_sensor filament_sensor" = {
        switch_pin = "PC15";
        pause_on_runout = true;
      };
      "temperature_sensor rpi_temp" = {
        sensor_type = "temperature_host";
      };
      "temperature_sensor mcu_temp" = {
        sensor_type = "temperature_mcu";
        min_temp = 0;
        max_temp = 100;
      };
    };
    firmwares.mcu = {
      enable = true;
      configFile = ./printer.cfg;
      serial = "/dev/serial/by-id/usb-Klipper_stm32g0b1xx_3C003B000350415339373620-if00";
      enableKlipperFlash = true;
    };
  };

  security.polkit.enable = true;
  services.moonraker = {
    enable = true;
    settings = { };
    allowSystemControl = true;
  };

  services.mainsail = {
    enable = true;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; }))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # Extra packages to install
  environment.systemPackages = [
    pkgs.xc
  ];

  # Use firmware even if it has a redistributable license
  hardware.enableRedistributableFirmware = lib.mkForce true;

  # Passwordless sudo for wheel group.
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.05";
}
