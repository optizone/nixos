{
  pkgs,
  username,
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
}
