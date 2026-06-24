{username, ...}: {
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
    user = "${username}";

    musicDirectory = "/home/${username}/zroot/ldata/media/music/";

    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };
  };

  # TODO: uid
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1001/";
  };
}
