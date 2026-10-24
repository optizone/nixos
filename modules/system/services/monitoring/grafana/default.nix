{
  config,
  host,
  lib,
  ...
}: {
  options = {
    custom.grafana = {
      local-only = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "";
      };

      # TODO: think of a global way to reference all hosts
      extra-hosts = let
        all-hosts =
          builtins.filter (it: it != host)
          ["rpi4-f" "rpi5-f" "oldboi" "ntt" "thinkpad"];
      in
        lib.mkOption {
          type = lib.types.listOf (lib.types.enum all-hosts);
          default = [];
          description = "";
        };
    };
  };

  config = {
    services = {
      grafana = {
        enable = true;

        provision = {
          enable = true;

          dashboards.settings.providers = [
            {
              name = "my dashboards";
              disableDeletion = true;
              options = {
                path = "/etc/grafana-dashboards";
                foldersFromFilesStructure = true;
              };
            }
          ];

          datasources.settings.datasources = let
            host-to-source = host: {
              name = "Prometheus-${host}";
              type = "prometheus";
              # BUG: will not work with overriden ports
              url = "http://${host}:${toString config.services.prometheus.port}";
              editable = false;
            };
          in
            [
              ((host-to-source "localhost") // {isDefault = true;})
            ]
            ++ lib.optionals (!config.custom.grafana.local-only)
            (builtins.map
              host-to-source
              config.custom.grafana.extra-hosts);
        };

        settings = {
          server.http_addr =
            if config.custom.grafana.local-only
            then "127.0.0.1"
            else "0.0.0.0";
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
        "/etc/grafana-dashboards"
      ];
    };

    environment.etc = {
      "grafana-dashboards/node-exporter.json".source =
        ./node-exporter.json;
      "grafana-dashboards/smartctl_exporter_dasboard.json".source =
        ./smartctl_exporter_dasboard.json;
    };
  };
}
