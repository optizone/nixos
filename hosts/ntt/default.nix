{
  config,
  username,
  host,
  hostId,
  stateVersion,
  ...
}: {
  # =======================================================

  imports = [
    ../../core/znode.nix

    ../../core/system/bootloader.nix
    ../../core/system/security.nix
    ../../core/system/sops.nix
    ../../core/system/settings.nix

    ./disks.nix
    ./hardware-configuration.nix

    ../../core/services/srv-utils/openssh.nix
    ../../core/services/srv-utils/avahi.nix
    ../../core/services/srv-utils/smb.nix
    ../../core/services/media/immich.nix

    ../../core/services/monitoring/prometheus.nix
    ../../core/services/monitoring/smartd.nix

    ../../home/flavours/nixos-module.nix
  ];

  # =======================================================

  nix.settings = {
    substituters = [
      "http://thinkpad.local"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    keep-outputs = true;
    keep-derivations = true;
  };

  nixpkgs.config.allowUnfree = false;
  system.stateVersion = "${stateVersion}";

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["ru_RU.UTF-8/UTF-8"];

  # =======================================================

  home-manager.users.${username} = {
    imports = [
      ../../home/terminal/apps/macchina
      ../../home/terminal/apps/starship.nix
      ../../home/terminal/shells/bash.nix
      ../../home/terminal/shells/fish.nix
      ../../home/terminal/apps/eza
      ../../home/terminal/apps/bat.nix
      ../../home/terminal/apps/zoxide.nix
    ];
  };

  programs.git.enable = true;

  services.v2raya.enable = true;

  # =======================================================

  services.smartd.devices = [{device = "/dev/sda";}];

  networking.hostName = "${host}";
  networking.hostId = "${hostId}";

  sops.secrets."user-pass-hash/${host}".neededForUsers = true;
  sops.secrets."root-pass-hash/${host}".neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets."root-pass-hash/${host}".path;
  users.users.${username}.hashedPasswordFile = config.sops.secrets."user-pass-hash/${host}".path;

  systemd.tmpfiles.rules = [
    "d /zroot 0750 ${username} users"

    "d /zroot/ldata 0750 ${username} users"
    "d /zroot/ldata/backups 0750 ${username} users"
    "d /zroot/ldata/builds 0750 ${username} users"
    "d /zroot/ldata/code 0750 ${username} users"
    "d /zroot/ldata/disk-images 0750 ${username} users"
    "d /zroot/ldata/media 0750 ${username} users"
    "d /zroot/ldata/secrets 0750 ${username} users"
    "d /zroot/ldata/wiki 0750 ${username} users"
    "d /zroot/ldata/persist 0750 ${username} users"

    "d /zroot/nas 0750 ${username} users"
    "d /zroot/shuttles 0750 ${username} users"
    "d /zroot/notes 0750 ${username} users"

    # NOTE: for future
    "L /home/${username}/zroot - - - - /zroot"

    # FIXME: shuttles
  ];
}
