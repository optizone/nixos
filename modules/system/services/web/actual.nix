{host, ...}: {
  services.actual = {
    enable = true;
    settings.port = 3001;
  };

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/private/actual";
        user = "nobody";
        group = "nogroup";
      }
    ];
  };
}
