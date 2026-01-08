{ username, ... }:
{
  services.lidarr = {
    enable = true;
    openFirewall = true;

    user = "${username}";
    group = "users";
    dataDir = "/srv/lidarr";
  };
}
