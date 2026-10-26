_: {
  services.borgbackup.jobs = {
    persist-to-ntt = {
      paths = [
        "/zroot/ldata/persist/rpi4-f"
      ];
      repo = "borg@ntt:/zroot/ldata/backups/rpi4-f";
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /zroot/ldata/secrets/id_ed25519_borg_rpi4-f";
      compression = "none"; # btrfs compression is enabled
      startAt = "daily";
    };

    persist-to-thinkpad = {
      paths = [
        "/zroot/ldata/persist/rpi4-f"
      ];
      repo = "borg@thinkpad.local:/zroot/ldata/backups/rpi4-f";
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i /zroot/ldata/secrets/id_ed25519_borg_rpi4-f";
      compression = "lzma"; # FIXME: none when moved to disko
      startAt = "daily";
    };
  };
}
