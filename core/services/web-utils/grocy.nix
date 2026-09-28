{
  domain,
  host,
  ...
}: {
  services.grocy = {
    enable = true;
    hostName = "grocy.${domain}";

    nginx = {
      enableSSL = false;
    };
  };

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/grocy";
        user = "grocy";
        group = "nginx";
      }
    ];
  };
}
