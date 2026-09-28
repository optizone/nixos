{host, ...}: {
  services.matter-server = {
    enable = true;
    port = 5580;
  };

  networking.firewall.allowedTCPPorts = [5580];

  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 root root"
  ];

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/private/matter-server";
        user = "nobody";
        group = "nogroup";
      }
    ];
  };
}
