{ username, ... }:
let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=60s";
  uid = "${username}";
  gid = "users";
  credentialsPath = "/run/secrets/${username}/smb-client-auth";

  options = [ "${automount_opts},credentials=${credentialsPath},rw,uid=${uid},gid=${gid}" ];
  fsType = "cifs";

  nasPath = "/home/${username}/zroot/nas/rpi4-f";
in
{
  sops.secrets."${username}/smb-client-auth" = { };

  services.samba.enable = true;

  fileSystems = {
    "${nasPath}/backups" = {
      device = "//rpi4-f/backups";
      inherit options fsType;
    };

    "${nasPath}/disk-images" = {
      device = "//rpi4-f/disk-images";
      inherit options fsType;
    };

    "${nasPath}/wiki" = {
      device = "//rpi4-f/wiki";
      inherit options fsType;
    };

    "${nasPath}/media" = {
      device = "//rpi4-f/media";
      inherit options fsType;
    };

    "${nasPath}/home" = {
      device = "//rpi4-f/home/optizone";
      inherit options fsType;
    };
  };
}
