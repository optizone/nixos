_: {
  services.zigbee2mqtt = {
    enable = true;

    dataDir = "/var/lib/zigbee2mqtt";
    # TODO: copy from imperative
    settings = { };
  };
}
