{ username, ... }:
{
  systemd.tmpfiles.rules = [
    # "d /home/${username}/zroot/shuttles/k1 0755 ${username} users"
    "L /home/${username}/zroot/shuttles/k1 - - - - /run/media/${username}/652e8438-1efd-4abc-b9fb-13379adf7cd0"
  ];
}
