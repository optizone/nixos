_: {
  services.zigbee2mqtt = {
    enable = true;

    dataDir = "/var/lib/zigbee2mqtt";

    settings = {
      serial = {
        port = "/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_225dd3734053ef11a5602de0174bec31-if00-port0";
        adapter = "ember";
      };

      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://localhost:1883";
      };

      advanced = {
        channel = 11;
        network_key = [
          187
          229
          185
          216
          152
          156
          41
          114
          190
          168
          42
          193
          228
          208
          76
          68
        ];
        pan_id = 663;
        ext_pan_id = [
          13
          236
          94
          86
          107
          239
          248
          59
        ];
      };

      frontend = {
        enabled = true;
        port = 10801;
      };

      homeassistant.enabled = true;
    };
  };
}
