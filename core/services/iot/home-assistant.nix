{username, ...}: {
  # TODO: make configurable
  hardware.bluetooth.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [
        "home-assistant:/config"
        "/znode/share/backups/home-assistant:/config/backups"
        "/var/run/dbus:/run/dbus:ro" # Bluetooth support
      ];
      capabilities = {
        "NET_ADMIN" = true;
        "NET_RAW" = true;
      };
      environment.TZ = "Europe/Moscow";
      image = "ghcr.io/home-assistant/home-assistant:2026.1.3";
      extraOptions = [
        "--network=host"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /znode/share/backups/home-assistant 0750 ${username} users"
  ];

  networking.firewall.allowedTCPPorts = [8123];
}
