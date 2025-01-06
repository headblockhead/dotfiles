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
  ###### interface
  options = {
    services.dnsmasq-iot = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkPackageOption pkgs "dnsmasq" { };
      resolveLocalQueries = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      alwaysKeepRunning = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options.server = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };

        };
        default = { };
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.dnsmasq-iot.settings = {
      dhcp-leasefile = lib.mkDefault "${stateDir}/dnsmasq.leases";
      conf-file = lib.mkDefault (lib.optional cfg.resolveLocalQueries "/etc/dnsmasq-conf.conf");
      resolv-file = lib.mkDefault (lib.optional cfg.resolveLocalQueries "/etc/dnsmasq-resolv.conf");
    };

    networking.nameservers =
      lib.optional cfg.resolveLocalQueries "127.0.0.1";

    networking.resolvconf = lib.mkIf cfg.resolveLocalQueries {
      useLocalResolver = lib.mkDefault true;

      extraConfig = ''
        dnsmasq_conf=/etc/dnsmasq-conf.conf
        dnsmasq_resolv=/etc/dnsmasq-resolv.conf
      '';

      subscriberFiles = [
        "/etc/dnsmasq-conf.conf"
        "/etc/dnsmasq-resolv.conf"
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
