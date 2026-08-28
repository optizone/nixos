{
  username,
  pkgs,
  config,
  ...
}: {
  home-manager.users.${username}.home.packages = with pkgs; [
    sysbench
    stress-ng
    smartmontools
    wakatime-cli
    iperf
    htop
  ];

  services = {
    wakapi = {
      enable = true;
      settings.server.port = 3008;
    };

    prometheus = {
      enable = true;
      port = 9090;

      exporters.smartctl = {
        enable = true;
        port = 9633;
      };

      exporters.node = {
        enable = true;
        port = 9100;
        enabledCollectors = [
          "systemd"
          "ethtool"
        ];
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }

        {
          job_name = "smart";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.smartctl.port}"];
            }
          ];
        }
      ];
    };

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
        server.http_port = 3010;

        security = {
          # TODO: secret
          secret_key = "SW2YcwTIb9zpOOhoPsMm";
        };
      };
    };

    smartd = {
      enable = true;
    };
  };

  # HACK: set capabilities so smartctl does not fail.
  # TODO: security considerations
  systemd.services.prometheus-smartctl-exporter = {
    serviceConfig = {
      AmbientCapabilities = [
        "CAP_SYS_RAWIO"
        "CAP_SYS_ADMIN"
        "CAP_DAC_OVERRIDE"
      ];
      CapabilityBoundingSet = [
        "CAP_SYS_RAWIO"
        "CAP_SYS_ADMIN"
        "CAP_DAC_OVERRIDE"
      ];
    };
  };
}
