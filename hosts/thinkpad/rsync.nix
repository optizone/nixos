{ username, pkgs, ... }:
let
  rsync-bak = pkgs.writeShellScript "rsync-bak" ''
    ${pkgs.rsync}/bin/rsync \
        --recursive \
        --update \
        --compress \
        --partial \
        --times \
        --links \
        --copy-unsafe-links \
        --hard-links \
        -e '${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/${username}' \
        $@
  '';

  zrootPath = "/home/${username}/zroot";
  dataPath = "${zrootPath}/ldata";
  nasesPath = "${zrootPath}/nas";
  shuttles = "${zrootPath}/shuttles";

  backup-all = pkgs.writeShellScript "backup-all" ''
    # local -> nas
    ${rsync-bak} "${dataPath}/wiki/" "${nasesPath}/rpi5-k/wiki"
    ${rsync-bak} "${dataPath}/disk-images/" "${nasesPath}/rpi5-k/disk-images"
    ${rsync-bak} "${dataPath}/media/" "${nasesPath}/rpi5-k/media"
    ${rsync-bak} "${dataPath}/code/" "${nasesPath}/rpi5-k/backups/code"

    ${rsync-bak} "${zrootPath}/" \
        "${nasesPath}/rpi5-k/backups/zroot" \
        --exclude-from "${zrootPath}/.gitignore" 

    # nas -> local
    ${rsync-bak} "${nasesPath}/rpi5-k/wiki/" "${dataPath}/wiki"
    ${rsync-bak} "${nasesPath}/rpi5-k/backups/home-assistant/" \
        "${dataPath}/backups/home-assistant"

    # dayly (week) and mounthly (year) retention
    ${rsync-bak} "root@rpi5-k:/znode/persist" "${dataPath}/backups/rpi5-k/$(date +%A)" \
        --archive --delete-after
    ${rsync-bak} "root@rpi5-k:/znode/persist" "${dataPath}/backups/rpi5-k/$(date +%B)" \
        --archive --delete-after
  '';

  zsync-k1-script = pkgs.writeShellScript "zsync-k1" ''
    # local -> shuttle
    ${rsync-bak} "${zrootPath}/notes/" "${shuttles}/k1/zroot/notes" --progress
    ${rsync-bak} "${zrootPath}/ldata/" "${shuttles}/k1/zroot/ldata" \
        --exclude "media/" \
        --exclude "builds/" \
        --progress
    ${rsync-bak} "${zrootPath}/nixos/" "${shuttles}/k1/zroot/nixos" --progress
    ${rsync-bak} "${zrootPath}/misc/" "${shuttles}/k1/zroot/misc" --progress

    ${rsync-bak} "/nix/store/" "${shuttles}/k1/nix/store" --progress
  '';

  zsync-k1 = pkgs.writeScriptBin "zsync-k1" zsync-k1-script;
in
{
  systemd.timers."backup-timer" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
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

  environment.systemPackages = [ zsync-k1 ];
}
