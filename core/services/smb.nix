{
  username,
  lib,
  pkgs,
  host,
  ...
}:
{
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.68. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      backups = {
        "path" = "/export/backups/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
      };

      disk-images = {
        "path" = "/export/disk-images/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
      };

      kiwix-images = {
        "path" = "/export/kiwix-images/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
      };

      media = {
        "path" = "/export/media/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowPing = true;

  systemd.tmpfiles.rules = [
    "d /export/backups 0770 ${username} users - -"
    "d /export/disk-images 0770 ${username} users - -"
    "d /export/kiwix-images 0770 ${username} users - -"
    "d /export/media 0770 ${username} users - -"
  ];

  systemd.services.samba-smbd.serviceConfig.ExecStartPre = [
    ''
      smb_password="$(cat /run/secrets/${host}/smb-pass)"
      echo -e "$smb_password\n$smb_password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s smbuser
    ''
  ];

  sops.secrets."${host}/smb-pass" = {
    restartUnits = [ "samba-smbd.service" ];
  };
}
