{ username, pkgs, ... }:
let
  rsync-bak = pkgs.writeShellScript "rsync-bak" ''
    ${pkgs.rsync}/bin/rsync --recursive --update --compress --partial --times \
        -e '${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/${username}' \
        $@
  '';

  zrootPath = "/home/${username}/zroot";
  dataPath = "${zrootPath}/ldata";
  nasesPath = "${zrootPath}/nas";

  backup-all = pkgs.writeShellScript "backup-all" ''
    # local -> nas
    ${rsync-bak} "${dataPath}/kiwix-images/" "${nasesPath}/rpi5-k/kiwix-images"
    ${rsync-bak} "${dataPath}/disk-images/" "${nasesPath}/rpi5-k/disk-images"
    ${rsync-bak} "${dataPath}/media/" "${nasesPath}/rpi5-k/media" 
    ${rsync-bak} "${dataPath}/code/" "${nasesPath}/rpi5-k/backups/code" 

    ${rsync-bak} "${zrootPath}/" "${nasesPath}/rpi5-k/backups/zroot" \
        --exclude-from "${zrootPath}/.gitignore" 

    # nas -> local
    ${rsync-bak} "${nasesPath}/rpi5-k/kiwix-images/" "${dataPath}/kiwix-images" 
    ${rsync-bak} "${nasesPath}/rpi5-k/backups/home-assistant/" "${dataPath}/backups/home-assistant" \
        --delete-after

    # FIXME:  please ):
    rm -r "${dataPath}/backups/rpi5-k/stale"
    cp -r "${dataPath}/backups/rpi5-k/latest" "${dataPath}/backups/rpi5-k/stale"
    ${rsync-bak} "root@rpi5-k:/persist" "${dataPath}/backups/rpi5-k/latest" \
        --archive --delete-after
  '';
in
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
    script = "${backup-all}";

    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };
}
