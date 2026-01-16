{ domain, ... }:
{

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

    virtualHosts."jellyfin.${domain}" = {
      # enableACME = true;
      # forceSSL = true;

      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;";
        # + "proxy_set_header Upgrade $http_upgrade;"
        # + "proxy_set_header Connection 'upgrade';"
        # + "proxy_set_header Host $host;"
        # + "proxy_cache_bypass $http_upgrade;";
      };
    };

    virtualHosts."adguard.${domain}" = {
      # enableACME = true;
      # forceSSL = true;

      locations."/" = {
        proxyPass = "http://localhost:3000";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
  };
}
