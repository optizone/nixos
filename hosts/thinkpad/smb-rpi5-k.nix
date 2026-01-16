{ username, ... }:
let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  uid = "${username}";
  gid = "users";
  credentialsPath = "/run/secrets/thinkpad/smb-client-auth";

  options = [ "${automount_opts},credentials=${credentialsPath},rw,uid=${uid},gid=${gid}" ];
  fsType = "cifs";
in
{
  sops.secrets."thinkpad/smb-client-auth" = { };

  services.samba.enable = true;

  fileSystems = {
    "/home/${username}/zroot/nas/rpi5-k/backups" = {
      device = "//rpi5-k/backups";
      inherit options fsType;
    };

    "/home/${username}/zroot/nas/rpi5-k/disk-images" = {
      device = "//rpi5-k/disk-images";
      inherit options fsType;
    };

    "/home/${username}/zroot/nas/rpi5-k/kiwix-images" = {
      device = "//rpi5-k/kiwix-images";
      inherit options fsType;
    };

    "/home/${username}/zroot/nas/rpi5-k/media" = {
      device = "//rpi5-k/media";
      inherit options fsType;
    };

    "/home/${username}/zroot/nas/rpi5-k/home" = {
      device = "//rpi5-k/home/optizone";
      inherit options fsType;
    };
  };
}
