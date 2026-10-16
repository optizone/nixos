{host, ...}: let
  # NOTE: to gen key run `ssh-keygen -N '' -t ed25519 -f id_ed25519_borg`
  hosts = [
    {
      host = "rpi4-f";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIMeGxYZ0M+VIPyQ0yF7TKViIexfIr1BQ3htYFGsXJ2d optizone@rpi4-f";
    }
    {
      host = "rpi5-k";
      key = "";
    }
    {
      host = "oldboi";
      key = "";
    }
    {
      host = "ntt";
      key = "";
    }
    {
      host = "thinkpad";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGk7QjmY3Tx9hsh/6E/bDo42zAFC1Yqs6uPtrzvk86AV thinkpad@thinkpad";
    }
  ];
  hosts_filtered = builtins.filter (it: it.host != host) hosts;
  repos = builtins.listToAttrs (map (it: {
      name = it.host;
      value = {
        authorizedKeys = [it.key];
        path = "/zroot/ldata/backups/${it.host}";
        allowSubRepos = true;
      };
    })
    hosts_filtered);
in {
  services.borgbackup.repos = repos;

  services.openssh.settings.AllowUsers = [
    "borg"
  ];

  # HACK: needed so borg can cd into `/zroot/ldata/backups`
  users.users."borg".extraGroups = ["users"];
}
