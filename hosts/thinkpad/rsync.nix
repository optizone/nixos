{
  username,
  pkgs,
  ...
}: let
  backup = pkgs.writeShellScript "backup" ''
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

  sync = pkgs.writeShellScript "sync" ''
    ${backup} --delete-after $@
  '';

  zrootPath = "/home/${username}/zroot";
  dataPath = "${zrootPath}/ldata";
  nasesPath = "${zrootPath}/nas";
  shuttles = "${zrootPath}/shuttles";

  zback-script = pkgs.writeShellScript "zback" ''
    # local -> nas
    ${backup} "${dataPath}/wiki/" "${nasesPath}/rpi5-k/wiki"
    ${backup} "${dataPath}/disk-images/" "${nasesPath}/rpi5-k/disk-images"
    ${backup} "${dataPath}/media/" "${nasesPath}/rpi5-k/media"
    ${backup} "${dataPath}/code/" "${nasesPath}/rpi5-k/backups/code"

    ${backup} "${zrootPath}/" \
        "${nasesPath}/rpi5-k/backups/zroot" \
        --exclude-from "${zrootPath}/.gitignore"

    # nas -> local
    ${backup} "${nasesPath}/rpi5-k/wiki/" "${dataPath}/wiki"
    ${backup} "${nasesPath}/rpi5-k/backups/home-assistant/" \
        "${dataPath}/backups/home-assistant"

    # dayly (week) and mounthly (year) retention
    ${backup} "root@rpi5-k:/znode/persist" "${dataPath}/backups/rpi5-k/$(date +%A)" \
        --archive --delete-after --exclude "build/" -A -X --numeric-ids --super
    ${backup} "root@rpi5-k:/znode/persist" "${dataPath}/backups/rpi5-k/$(date +%B)" \
        --archive --delete-after --exclude "build/" -A -X --numeric-ids --super
  '';

  zsync = pkgs.writeShellScriptBin "zsync" ''
    SHUTTLE="$1"
    if [ -z "$SHUTTLE" ]; then
        echo "USAGE: zsync <SHUTTLE>"
        exit 1
    fi

    # local -> shuttle
    ${sync} "${zrootPath}/notes/" "${shuttles}/$SHUTTLE/zroot/notes"
    ${sync} "${zrootPath}/ldata/" "${shuttles}/$SHUTTLE/zroot/ldata" \
        --exclude "media/" \
        --exclude "builds/"
    ${sync} "${zrootPath}/nixos/" "${shuttles}/$SHUTTLE/zroot/nixos"
    ${sync} "${zrootPath}/misc/" "${shuttles}/$SHUTTLE/zroot/misc"

    ${sync} "/nix/store/" "${shuttles}/$SHUTTLE/nix/store"
  '';

  zback = pkgs.writeShellScriptBin "zback" zback-script;
in {
  # TODO: find a way to toggle
  systemd.timers."backup-timer" = {
    wantedBy = ["timers.target"];
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
