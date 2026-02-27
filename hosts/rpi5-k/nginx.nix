{ domain, ... }:
{
  # TODO: move to a different section + enable firewall
  networking.firewall = {
    enable = false;

    allowedTCPPorts = [
      22
      80
      443
      59010
      59011
      57621
    ];

    allowedUDPPorts = [
      59010
      59011
      5353
    ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "jellyfin.${domain}" = {
        locations."/" = {
          proxyPass = "http://localhost:8096";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };

      "adguard.${domain}" = {
        locations."/" = {
          proxyPass = "http://localhost:3000";
          proxyWebsockets = true;
        };
      };

      "matter-server.${domain}" = {
        locations."/" = {
          proxyPass = "http://localhost:5580";
          proxyWebsockets = true;
        };
      };


      "zigbee2mqtt.${domain}" = {
        locations."/" = {
          proxyPass = "http://localhost:10801";
          proxyWebsockets = true;
        };
      };
    };
  };
}
