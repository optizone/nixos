{username, ...}: let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=60s";
  uid = "${username}";
  gid = "users";
  credentialsPath = "/run/secrets/smb-client-auth/${username}";

  options = ["${automount_opts},credentials=${credentialsPath},rw,uid=${uid},gid=${gid}"];
  fsType = "cifs";

  nasPath = "/home/${username}/zroot/nas/rpi5-k";
in {
  sops.secrets."smb-client-auth/${username}" = {};

  services.samba.enable = true;

  fileSystems = {
    "${nasPath}/backups" = {
      device = "//rpi5-k/backups";
      inherit options fsType;
    };

    "${nasPath}/disk-images" = {
      device = "//rpi5-k/disk-images";
      inherit options fsType;
    };

    "${nasPath}/wiki" = {
      device = "//rpi5-k/wiki";
      inherit options fsType;
    };

    "${nasPath}/media" = {
      device = "//rpi5-k/media";
      inherit options fsType;
    };

    "${nasPath}/home" = {
      device = "//rpi5-k/home/optizone";
      inherit options fsType;
    };
  };
}
