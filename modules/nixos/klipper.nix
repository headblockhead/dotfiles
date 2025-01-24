{
  networking.firewall.allowedTCPPorts = [ 80 443 7125 ];

  security.polkit.enable = true;
  services.moonraker = {
    enable = true;
    settings = {
      authorization = {
        trusted_clients = [
          "127.0.0.0/8"
          "192.168.1.0/24"
        ];
      };
    };
    group = "klipper";
    address = "0.0.0.0";
    port = 7125;
    allowSystemControl = true;
  };

  services.mainsail = {
    enable = true;
    hostName = "0.0.0.0";
  };

  users.groups.klipper = {
    gid = 982;
  };

  users.users.klipper = {
    uid = 982;
    group = "klipper";
    isSystemUser = true;
  };

  services.klipper = {
    enable = true;
    user = "klipper";
    group = "klipper";
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
        encoder_pins = "^EXP1_5, ^EXP1_3";
        click_pin = "^!EXP1_2";
      };
      board_pins = {
        aliases = "EXP1_1=PB5,EXP1_3=PA9,EXP1_5=PA10,EXP1_7=PB8,EXP1_9=<GND>,EXP1_2=PA15,EXP1_4=<RST>,EXP1_6=PB9,EXP1_8=PD6,EXP1_10=<5V>";
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
        screw1 = "38,35";
        screw2 = "242,35";
        screw3 = "242,214";
        screw4 = "38,214";
      };
      screws_tilt_adjust = {
        screw1 = "69,43";
        screw1_name = "front left screw";
        screw2 = "276,43";
        screw2_name = "front right screw";
        screw3 = "276,217";
        screw3_name = "rear right screw";
        screw4 = "69,217";
        screw4_name = "rear left screw";
        horizontal_move_z = 10;
        speed = 50;
        screw_thread = "CW-M4";
      };
      bed_mesh = {
        speed = 150;
        horizontal_move_z = 5;
        mesh_min = "38,35";
        mesh_max = "242,214";
        probe_count = "3,3";
        move_check_distance = 10;
        split_delta_z = 0.025;
        fade_start = 1;
        fade_end = 10;
        fade_target = 0;
        mesh_pps = "2,2";
        algorithm = "bicubic";
        bicubic_tension = 0.2;
      };
      safe_z_home = {
        home_xy_position = "140,130";
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
        rotation_distance = 7.492905;
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
      # Mainsail config
      virtual_sdcard = {
        path = "/var/lib/moonraker/gcodes";
      };
      display_status = { };
      pause_resume = { };
      "gcode_macro PAUSE" = {
        description = "Pause the actual running print";
        rename_existing = "PAUSE_BASE";
        gcode = "\n    PAUSE_BASE\n    _TOOLHEAD_PARK_PAUSE_CANCEL";
      };
      "gcode_macro RESUME" = {
        description = "Resume the actual running print";
        rename_existing = "RESUME_BASE";
        gcode = "\n     ##### read extrude from  _TOOLHEAD_PARK_PAUSE_CANCEL  macro #####\n     {% set extrude = printer['gcode_macro _TOOLHEAD_PARK_PAUSE_CANCEL'].extrude %}\n     #### get VELOCITY parameter if specified ####\n     {% if 'VELOCITY' in params|upper %}\n     {% set get_params = ('VELOCITY=' + params.VELOCITY)  %}\n     {%else %}\n     {% set get_params = \"\" %}\n     {% endif %}\n     ##### end of definitions #####\n     {% if printer.extruder.can_extrude|lower == 'true' %}\n     M83\n     G1 E{extrude} F2100\n     {% if printer.gcode_move.absolute_extrude |lower == 'true' %} M82 {% endif %}\n     {% else %}\n     {action_respond_info(\"Extruder not hot enough\")}\n     {% endif %}\n     RESUME_BASE {get_params}\n";
      };
      "gcode_macro CANCEL_PRINT" = {
        description = "Cancel the actual running print";
        rename_existing = "CANCEL_PRINT_BASE";
        variable_park = "True";
        gcode = "\n     ## Move head and retract only if not already in the pause state and park set to true\n     {% if printer.pause_resume.is_paused|lower == 'false' and park|lower == 'true'%}\n     _TOOLHEAD_PARK_PAUSE_CANCEL\n     {% endif %}\n     TURN_OFF_HEATERS\n     CANCEL_PRINT_BASE";
      };
      "gcode_macro _TOOLHEAD_PARK_PAUSE_CANCEL" = {
        description = "Helper: park toolhead used in PAUSE and CANCEL_PRINT";
        variable_extrude = 1;
        gcode = "\n     ##### set park positon for x and y #####\n     # default is your max posion from your printer.cfg\n     {% set x_park = printer.toolhead.axis_maximum.x|float - 5.0 %}\n     {% set y_park = printer.toolhead.axis_maximum.y|float - 5.0 %}\n     {% set z_park_delta = 2.0 %}\n     ##### calculate save lift position #####\n     {% set max_z = printer.toolhead.axis_maximum.z|float %}\n     {% set act_z = printer.toolhead.position.z|float %}\n     {% if act_z < (max_z - z_park_delta) %}\n     {% set z_safe = z_park_delta %}\n     {% else %}\n     {% set z_safe = max_z - act_z %}\n     {% endif %}\n     ##### end of definitions #####\n     {% if printer.extruder.can_extrude|lower == 'true' %}\n     M83\n     G1 E-{extrude} F2100\n     {% if printer.gcode_move.absolute_extrude |lower == 'true' %} M82 {% endif %}\n     {% else %}\n     {action_respond_info(\"Extruder not hot enough\")}\n     {% endif %}\n     {% if \"xyz\" in printer.toolhead.homed_axes %}\n     G91\n     G1 Z{z_safe} F900\n     G90\n     G1 X{x_park} Y{y_park} F6000\n     {% if printer.gcode_move.absolute_coordinates|lower == 'false' %} G91 {% endif %}\n     {% else %}\n     {action_respond_info(\"Printer not homed\")}\n     {% endif %}";
      };
    };
    firmwares.mcu = {
      enable = true;
      configFile = ./printer.cfg;
      serial = "/dev/serial/by-id/usb-Klipper_stm32g0b1xx_3C003B000350415339373620-if00";
      enableKlipperFlash = true;
    };
  };
}
