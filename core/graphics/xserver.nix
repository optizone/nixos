_: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,ru";
    };

    libinput = {
      enable = true;
    };
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = 10;
  };
}
