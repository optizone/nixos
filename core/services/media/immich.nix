{
  config,
  username,
  ...
}: {
  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";

      machine-learning.enable = false;

      openFirewall = true;
    };
  };

  fileSystems."${config.services.immich.mediaLocation}" = {
    device = "/zroot/ldata/media/gallery/immich";
    fsType = "none";
    options = ["bind"];
  };

  systemd.tmpfiles.rules = [
    "d /zroot/ldata/media/gallery 0750 ${username} users"
    "d /zroot/ldata/media/gallery/immich 0700 immich immich"
  ];
}
