_: {
  # TODO: make configurable
  hardware.bluetooth.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [
        "home-assistant:/config"
        "/var/run/dbus:/run/dbus:ro" # Bluetooth support
      ];
      environment.TZ = "Europe/Berlin";
      image = "ghcr.io/home-assistant/home-assistant:2026.1.2";
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
