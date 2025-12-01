_: {
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.68. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      "backups" = {
        "path" = "/export/backups/";
        "browseable" = "yes";
        "public" = "no";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "thinkpad";
        "force user" = "thinkpad";
      };

      "disk-images" = {
        "path" = "/export/disk-images/";
        "browseable" = "yes";
        "public" = "no";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "thinkpad";
        "force user" = "thinkpad";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowPing = true;

  systemd.tmpfiles.rules = [
    "d /export/backups 0770 thinkpad thinkpad - -"
    "d /export/disk-images 0770 thinkpad thinkpad - -"
  ];
}
