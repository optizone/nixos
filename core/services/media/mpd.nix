{username, ...}: {
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
    user = "${username}";

    settings = {
      bind_to_address = "127.0.0.1";
      port = 6600;

      music_directory = "/home/${username}/zroot/ldata/media/music/";

      audio_output = [
        {
          type = "pipewire";
          name = "My PipeWire Output";
        }
      ];
    };
  };

  # TODO: uid
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1001/";
  };
}
