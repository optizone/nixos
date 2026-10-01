{
  pkgs,
  username,
  host,
  ...
}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "${username}";
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
      }
    ];
  };
}
