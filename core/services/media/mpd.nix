{ username, ... }:
{
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
    user = "${username}";

    musicDirectory = "/home/${username}/zroot/ldata/media/music/";

    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };

    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';

  };

  # TODO: uid
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1001/";
  };
}
