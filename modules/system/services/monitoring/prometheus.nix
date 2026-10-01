{
  config,
  host,
  lib,
  ...
}: let
  with-smartd = config.services.smartd.enable;
in {
  services = {
    prometheus = {
      enable = true;
      port = 9090;

      exporters.smartctl = lib.mkIf with-smartd {
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

      scrapeConfigs =
        [
          {
            job_name = "node";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
              }
            ];
          }
        ]
        ++ lib.optional with-smartd
        {
          job_name = "smart";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.smartctl.port}"];
            }
          ];
        };
    };
  };

  # HACK: set capabilities so smartctl does not fail.
  # TODO: security considerations
  systemd.services.prometheus-smartctl-exporter = lib.mkIf with-smartd {
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

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/prometheus2";
        user = "prometheus";
        group = "prometheus";
      }
    ];
  };
}
