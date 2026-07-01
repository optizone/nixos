{username, ...}: {
  services.radarr = {
    enable = true;
    openFirewall = true;

    user = "${username}";
    group = "users";
    dataDir = "/srv/radarr";
  };
}
