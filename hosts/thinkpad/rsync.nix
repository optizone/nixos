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
        --info=progress2 \
        -e '${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/${username}' \
        $@
  '';

  zrootPath = "/home/${username}/zroot";
  dataPath = "${zrootPath}/ldata";
  nasesPath = "${zrootPath}/nas";
  shuttles = "${zrootPath}/shuttles";

  zback-script = pkgs.writeShellScript "zback" ''
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
        --archive --delete-after --exclude "build/" -A -X --numeric-ids --super
    ${rsync-bak} "root@rpi5-k:/znode/persist" "${dataPath}/backups/rpi5-k/$(date +%B)" \
        --archive --delete-after --exclude "build/" -A -X --numeric-ids --super

    # TODO: shuttle sync?
  '';

  zsync-script = pkgs.writeShellScript "zsync" ''
    [ -z "$1" ] && echo "Missing shuttle argument" && exit 1
    SHUTTLE=$1

    # local -> shuttle
    ${rsync-bak} "${zrootPath}/notes/" "${shuttles}/$SHUTTLE/zroot/notes"
    ${rsync-bak} "${zrootPath}/ldata/" "${shuttles}/$SHUTTLE/zroot/ldata" \
        --exclude "media/" \
        --exclude "builds/"
    ${rsync-bak} "${zrootPath}/nixos/" "${shuttles}/$SHUTTLE/zroot/nixos"
    ${rsync-bak} "${zrootPath}/misc/" "${shuttles}/$SHUTTLE/zroot/misc"

    ${rsync-bak} "/nix/store/" "${shuttles}/$SHUTTLE/nix/store"
  '';

  zsync = pkgs.writeScriptBin "zsync" zsync-script;
  zback = pkgs.writeScriptBin "zback" zback-script;
in
{
  # TODO: find a way to toggle
  systemd.timers."backup-timer" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "zback.service";
    };
  };

  systemd.services."zback" = {
    script = "${zback-script}";

    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };

  environment.systemPackages = [
    zsync
    zback
  ];
}
