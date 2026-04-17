_: {
  # TODO: make configurable
  hardware.bluetooth.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [
        "home-assistant:/config"
        "/export/backups/home-assistant:/config/backups"
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
}
