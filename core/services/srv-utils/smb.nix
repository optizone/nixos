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
    isSystemUser = true;
    group = "users";
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
        "hosts allow" = "192.168.88. 127.0.0.1 localhost";
        "protocol" = "smb3";
        "client min protocol" = "smb3";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      backups = {
        "path" = "/znode/share/backups/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
        "force group" = "users";
      };

      disk-images = {
        "path" = "/znode/share/disk-images/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
        "force group" = "users";
      };

      wiki = {
        "path" = "/znode/share/wiki/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
        "force group" = "users";
      };

      media = {
        "path" = "/znode/share/media/";
        "browseable" = "yes";
        "public" = "no";
        "writeable" = "yes";
        "valid users" = "smbuser";
        "force user" = "${username}";
        "force group" = "users";
      };

      home = {
        "path" = "/znode/share/home/";
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
    "d /znode/share/backups 0750 ${username} users"
    "d /znode/share/disk-images 0750 ${username} users"
    "d /znode/share/kiwix-images 0750 ${username} users"
    "d /znode/share/media 0750 ${username} users"
    "d /znode/share/home 0750 ${username} users"
    "d /znode/share/wiki 0750 ${username} users"
  ];

  systemd.services.samba-smbd.serviceConfig.ExecStartPre = [
    "${setSmbPass}"
  ];

  sops.secrets."${host}/smb-pass" = {
    restartUnits = [ "samba-smbd.service" ];
  };
}
