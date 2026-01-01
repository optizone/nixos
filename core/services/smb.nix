{
  username,
  lib,
  pkgs,
  host,
  ...
}:
let
  setSmbPass = pkgs.writeShellScript "samba-set-passwords" ''
    smb_password="$(cat /run/secrets/${host}/smb-pass)"
    echo -e "$smb_password\n$smb_password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s smbuser
  '';
in
{
  users.users.smbuser = {
    isNormalUser = true;
    extraGroups = [
      "users"
    ];
  };

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
        "min protocol" = "SMB3";
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
        "force group" = "users";
      };

      disk-images = {
        "path" = "/export/disk-images/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
        "force group" = "users";
      };

      kiwix-images = {
        "path" = "/export/kiwix-images/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
        "force group" = "users";
      };

      media = {
        "path" = "/export/media/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowPing = true;

  systemd.tmpfiles.rules = [
    "d /export/backups 0750 ${username} users"
    "d /export/disk-images 0750 ${username} users"
    "d /export/kiwix-images 0750 ${username} users"
    "d /export/media 0750 ${username} users"
  ];

  systemd.services.samba-smbd.serviceConfig.ExecStartPre = [
    "${setSmbPass}"
  ];

  sops.secrets."${host}/smb-pass" = {
    restartUnits = [ "samba-smbd.service" ];
  };
}
