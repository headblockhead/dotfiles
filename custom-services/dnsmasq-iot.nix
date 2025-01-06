{ config, lib, pkgs, ... }:
let
  cfg = config.services.dnsmasq-iot;
  dnsmasq = cfg.package;
  stateDir = "/var/lib/dnsmasq-iot";

  # True values are just put as `name` instead of `name=true`, and false values
  # are turned to comments (false values are expected to be overrides e.g.
  # lib.mkForce)
  formatKeyValue =
    name: value:
    if value == true
    then name
    else if value == false
    then "# setting `${name}` explicitly set to false"
    else lib.generators.mkKeyValueDefault { } "=" name value;

  settingsFormat = pkgs.formats.keyValue {
    mkKeyValue = formatKeyValue;
    listsAsDuplicateKeys = true;
  };

  dnsmasqConf = settingsFormat.generate "dnsmasq.conf" cfg.settings;

in

{

  imports = [
    (lib.mkRenamedOptionModule [ "services" "dnsmasq-iot" "servers" ] [ "services" "dnsmasq-iot" "settings" "server" ])
    (lib.mkRemovedOptionModule [ "services" "dnsmasq-iot" "extraConfig" ] "This option has been replaced by `services.dnsmasq-iot.settings`")
  ];

  ###### interface

  options = {

    services.dnsmasq-iot = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run dnsmasq.
        '';
      };

      package = lib.mkPackageOption pkgs "dnsmasq" { };

      resolveLocalQueries = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether dnsmasq should resolve local queries (i.e. add 127.0.0.1 to
          /etc/resolv.conf).
        '';
      };

      alwaysKeepRunning = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled, systemd will always respawn dnsmasq even if shut down manually. The default, disabled, will only restart it on error.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {

          freeformType = settingsFormat.type;

          options.server = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            example = [ "8.8.8.8" "8.8.4.4" ];
            description = ''
              The DNS servers which dnsmasq should query.
            '';
          };

        };
        default = { };
        description = ''
          Configuration of dnsmasq. Lists get added one value per line (empty
          lists and false values don't get added, though false values get
          turned to comments). Gets merged with

              {
                dhcp-leasefile = "${stateDir}/dnsmasq.leases";
                conf-file = optional cfg.resolveLocalQueries "/etc/dnsmasq-conf.conf";
                resolv-file = optional cfg.resolveLocalQueries "/etc/dnsmasq-resolv.conf";
              }
        '';
        example = lib.literalExpression ''
          {
            domain-needed = true;
            dhcp-range = [ "192.168.0.2,192.168.0.254" ];
          }
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    services.dnsmasq-iot.settings = {
      dhcp-leasefile = lib.mkDefault "${stateDir}/dnsmasq.leases";
      conf-file = lib.mkDefault (lib.optional cfg.resolveLocalQueries "/etc/dnsmasq-iot-conf.conf");
      resolv-file = lib.mkDefault (lib.optional cfg.resolveLocalQueries "/etc/dnsmasq-iot-resolv.conf");
    };

    networking.nameservers =
      lib.optional cfg.resolveLocalQueries "127.0.0.1";

    services.dbus.packages = [ dnsmasq ];

    users.users.dnsmasq = {
      isSystemUser = true;
      group = "dnsmasq";
      description = "Dnsmasq daemon user";
    };
    users.groups.dnsmasq = { };

    networking.resolvconf = lib.mkIf cfg.resolveLocalQueries {
      useLocalResolver = lib.mkDefault true;

      extraConfig = ''
        dnsmasq_conf=/etc/dnsmasq-iot-conf.conf
        dnsmasq_resolv=/etc/dnsmasq-iot-resolv.conf
      '';

      subscriberFiles = [
        "/etc/dnsmasq-iot-conf.conf"
        "/etc/dnsmasq-iot-resolv.conf"
      ];
    };

    systemd.services.dnsmasq-iot = {
      description = "Dnsmasq Daemon";
      after = [ "network.target" "systemd-resolved.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ dnsmasq ];
      preStart = ''
        mkdir -m 755 -p ${stateDir}
        touch ${stateDir}/dnsmasq.leases
        chown -R dnsmasq ${stateDir}
        touch /etc/dnsmasq-iot-{conf,resolv}.conf
        dnsmasq --test
      '';
      serviceConfig = {
        Type = "dbus";
        BusName = "uk.org.thekelleys.dnsmasq";
        ExecStart = "${dnsmasq}/bin/dnsmasq -k --enable-dbus --user=dnsmasq -C ${dnsmasqConf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        PrivateTmp = true;
        ProtectSystem = true;
        ProtectHome = true;
        Restart = if cfg.alwaysKeepRunning then "always" else "on-failure";
      };
      restartTriggers = [ config.environment.etc.hosts.source ];
    };
  };
}
