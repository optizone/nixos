{host, ...}: {
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = ["pattern readwrite #"];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/mosquitto";
        user = "mosquitto";
        group = "mosquitto";
      }
    ];
  };
}
