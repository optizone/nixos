{
  config,
  username,
  host,
  ...
}: {
  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";

      machine-learning.enable = true;

      openFirewall = true;
    };
  };

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/postgresql";
        user = "postgresql";
        group = "postgresql";
      }
      {
        directory = "/var/lib/redis-immich";
        user = "redis-immich";
        group = "redis-immich";
      }
    ];
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
