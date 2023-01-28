{ pkgs, ... }: 
let
hass-api-key = (builtins.readFile /root/hassapi);
in
  {
  imports = [
    ../../nixos-thinkpad-dock
  ];
  hardware = {
    thinkpad-dock = {
      enable = true;

      # Tell my HomeAssistant server that the laptop has been docked.
      dockEvent = ''
      ${pkgs.curl}/bin/curl -X POST -H 'Authorization: Bearer ${hass-api-key}' -H 'Content-Type: application/json' -d '{ \"state\": true}' http://192.168.155.222:8123/api/states/sensor.Laptop_Docked > /tmp/acpiDock.log
      '';
      undockEvent = ''
${pkgs.curl}/bin/curl -X POST -H 'Authorization: Bearer ${hass-api-key}' -H 'Content-Type: application/json' -d ' {\"state\": false}' http://192.168.155.222:8123/api/states/sensor.Laptop_Docked > /tmp/acpiUndock.log
      '';
    };
  };
}
