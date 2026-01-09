_: {
  services.adguardhome = {
    enable = true;
    openFirewall = true;

    settings = {
      dns = {
        upstream_dns = [
          "[/local/]192.168.68.1"
          "[/optizone.duckdns.org/]192.168.68.1"
          "https://dns10.quad9.net/dns-query"
        ];

        bootstrap_dns = [ "1.1.1.1:53" ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
      };
    };
  };
}
