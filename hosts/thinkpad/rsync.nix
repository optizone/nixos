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

  zback = pkgs.writeShellScriptBin "zback" ''
    target="$1"

    if [ -z "$target" ] || [ "$target" = "rpi4-f" ]; then
      echo Backing up to 'rpi4-f'
      ${backup} "/zroot/notes/" "/zroot/nas/rpi4-f/notes"
      ${backup} "/zroot/nixos/" "/zroot/nas/rpi4-f/nixos"
      ${backup} "/zroot/ldata/secrets/" "/zroot/nas/rpi4-f/ldata/secrets"
      ${backup} "/zroot/ldata/media/music/" "/zroot/nas/rpi4-f/ldata/media/music"
      ${backup} "/zroot/ldata/code/" "/zroot/nas/rpi4-f/ldata/code" \
        --exclude ".direnv" \
        --exclude ".venv"

      echo Backing up from 'rpi4-f'
      # dayly (week) and mounthly (year) retention
      ${backup} "/zroot/nas/rpi4-f/ldata/persist/" "/zroot/ldata/backups/rpi4-f/$(date +%A)" \
        --archive --delete-after -A -X --numeric-ids --super
      ${backup} "/zroot/nas/rpi4-f/ldata/persist/" "/zroot/ldata/backups/rpi4-f/$(date +%B)" \
        --archive --delete-after -A -X --numeric-ids --super
      echo "============ DONE ================"
      echo
    fi


    if [ -z "$target" ] || [ "$target" = "rpi5-k" ]; then
      echo Backing up to 'rpi5-k'
      ${backup} "/zroot/notes/" "/zroot/nas/rpi5-k/backups/zroot/notes"
      ${backup} "/zroot/nixos/" "/zroot/nas/rpi5-k/backups/zroot/nixos" \
        --exclude /result
      # FIXME: rpi5-k does not share zroot yet
      ${backup} "/zroot/ldata/code/" "/zroot/nas/rpi5-k/backups/code" \
        --exclude "/builds" \
        --exclude ".direnv" \
        --exclude ".venv"
      ${backup} "/zroot/ldata/media/" "/zroot/nas/rpi5-k/media"
      ${backup} "/zroot/ldata/disk-images/" "/zroot/nas/rpi5-k/disk-images"
      ${backup} "/zroot/ldata/wiki/" "/zroot/nas/rpi5-k/wiki"
      ${backup} "/zroot/ldata/secrets/" "/zroot/nas/rpi5-k/backups/secrets"

      echo Backing up from 'rpi5-k'
      ${backup} "/zroot/nas/rpi5-k/ldata/backups/home-assistant/" \
          "/zroot/ldata/backups/home-assistant"

      # dayly (week) and mounthly (year) retention
      ${backup} "root@rpi5-k:/znode/persist" "/zroot/ldata/backups/rpi5-k/$(date +%A)" \
        --archive --delete-after --exclude "build/" -A -X --numeric-ids --super
      ${backup} "root@rpi5-k:/znode/persist" "/zroot/ldata/backups/rpi5-k/$(date +%B)" \
        --archive --delete-after --exclude "build/" -A -X --numeric-ids --super
      echo "============ DONE ================"
    fi

    if [ "$target" = "k1" ]; then
      echo Backing up to 'k1'
      ${backup} "/zroot/notes/" "/zroot/shuttles/k1/zroot/ldata/backups/zroot/notes"
      ${backup} "/zroot/nixos/" "/zroot/shuttles/k1/zroot/ldata/backups/zroot/nixos"
      ${backup} "/zroot/ldata/" "/zroot/shuttles/k1/zroot/ldata/backups/zroot/nixos" \
        --exclude "/media" \
        --exclude "/builds" \
        --exclude ".direnv" \
        --exclude ".venv"

      ${backup} "/nix/store/" "/zroot/shuttles/k1/nix/store"
      echo "============ DONE ================"
    fi

    if [ "$target" = "k2" ]; then
      echo Backing up to 'k2'
      ${backup} "/zroot/notes/" "/zroot/shuttles/k2/zroot/ldata/backups/zroot/notes"
      ${backup} "/zroot/nixos/" "/zroot/shuttles/k2/zroot/ldata/backups/zroot/nixos"
      ${backup} "/zroot/ldata/" "/zroot/shuttles/k2/zroot/ldata/backups/zroot/nixos" \
        --exclude "/media" \
        --exclude "/builds" \
        --exclude ".direnv" \
        --exclude ".venv"

      ${backup} "/nix/store/" "/zroot/shuttles/k2/nix/store"
      echo "============ DONE ================"
    fi

    if [ "$target" = "k3" ]; then
      echo Backing up to 'k3'
      ${backup} "/zroot/notes/" "/zroot/shuttles/k3/zroot/ldata/backups/zroot/notes"
      ${backup} "/zroot/nixos/" "/zroot/shuttles/k3/zroot/ldata/backups/zroot/nixos"
      ${backup} "/zroot/ldata/" "/zroot/shuttles/k3/zroot/ldata/backups/zroot/nixos" \
        --exclude "/media" \
        --exclude "/builds" \
        --exclude ".direnv" \
        --exclude ".venv"

      ${backup} "/nix/store/" "/zroot/shuttles/k3/nix/store"
      echo "============ DONE ================"
    fi
  '';
  # TODO: cargo target ldata/builds dir
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
    script = "zback";

    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
    };
  };

  # systemd.tmpfiles = [
  #   "w /file/to/write-to - - - - ${code-exclude}"
  # ];

  environment.systemPackages = [
    zback
  ];
}
