{
  username,
  pkgs,
  host,
  ...
}: {
  home-manager.users.${username}.home.packages = with pkgs; [
    wakatime-cli
  ];

  services = {
    wakapi = {
      enable = true;
      settings.server.port = 3008;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 root root"
  ];

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/private/wakapi";
        user = "nobody";
        group = "nogroup";
      }
    ];
  };
}
