{host, ...}: let
  # NOTE: to gen key run `ssh-keygen -N '' -t ed25519 -f id_ed25519_borg`
  hosts = [
    {
      host = "rpi4-f";
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIMeGxYZ0M+VIPyQ0yF7TKViIexfIr1BQ3htYFGsXJ2d"];
    }
    {
      host = "rpi5-k";
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXRpgVsn0P4RWbWCIDEkWGV8+fBi2JXEWprixXmYXIh"];
    }
    {
      host = "oldboi";
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMhUH64qe6d6UJNjWF4vAmn9wZR3LgomWBLcfl0oFneJ"];
    }
    {
      host = "ntt";
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKYEefdViLU3BChGdjRDkdoo6EG3dN2W8+puZqib1BF"];
    }
    {
      host = "thinkpad";
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrNxBrLP9nExTDakNj5dD4F4ml1lNicwpUJMrNUpPFz"];
    }
  ];
  hosts_filtered = builtins.filter (it: it.host != host) hosts;
  repos = builtins.listToAttrs (map (it: {
      name = it.host;
      value = {
        authorizedKeys = it.keys;
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
