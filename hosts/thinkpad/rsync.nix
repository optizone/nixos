{ username, pkgs, ... }:
{
  systemd.timers."backup-timer" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "backup-all.service";
    };
  };

  systemd.services."backup-all" = {
    script = ''
      ${pkgs.rsync}/bin/rsync -rpu \
          -e '${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/id_github' \
          /home/${username}/zroot/data/kiwix-images/ \
          nixos@rpi5-k:/export/kiwix-images

      ${pkgs.rsync}/bin/rsync -rpu \
          -e '${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/id_github' \
          /home/${username}/zroot/data/disk-images/ \
          nixos@rpi5-k:/export/disk-images

      ${pkgs.rsync}/bin/rsync -rpu \
          -e '${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/id_github' \
          /home/${username}/code/
          nixos@rpi5-k:/export/backups/code

      ${pkgs.rsync}/bin/rsync -rpu \
          -e '${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/id_github' \
          --exclude-from /home/${username}/zroot/.gitignore \
          /home/${username}/zroot/ \
          nixos@rpi5-k:/export/backups/zroot
    '';

    serviceConfig = {
      Type = "oneshot";
      # TODO: username: default shell cant start
      User = "root";
    };
  };
}
