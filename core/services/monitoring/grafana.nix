{
  config,
  host,
  ...
}: {
  services = {
    grafana = {
      enable = true;

      provision = {
        enable = true;

        # dashboards.settings.providers = [
        #   {
        #     name = "my dashboards";
        #     disableDeletion = true;
        #     options = {
        #       path = "/etc/grafana-dashboards";
        #       foldersFromFilesStructure = true;
        #     };
        #   }
        # ];

        # TODO: localhost + datasources from other nodes
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
            isDefault = true;
            editable = false;
          }
        ];
      };

      settings = {
        server.http_addr = "127.0.0.1";
        server.http_port = 3010;

        security = {
          # TODO: secret
          secret_key = "SW2YcwTIb9zpOOhoPsMm";
        };
      };
    };
  };

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/grafana";
        user = "grafana";
        group = "grafana";
      }
    ];
  };
}
