{username, ...}: let
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=60s";
  uid = "${username}";
  gid = "users";
  credentialsPath = "/run/secrets/smb-client-auth/${username}";

  options = ["${automount_opts},credentials=${credentialsPath},rw,uid=${uid},gid=${gid}"];
  fsType = "cifs";
in {
  sops.secrets."smb-client-auth/${username}" = {};

  services.samba.enable = true;

  fileSystems = {
    "/zroot/nas/ntt" = {
      device = "//ntt/zroot";
      inherit options fsType;
    };
  };
}
