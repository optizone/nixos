{
  config,
  nixos-raspberrypi,
  username,
  host,
  hostId,
  stateVersion,
  pkgs,
  ...
}: {
  # =======================================================

  imports = with nixos-raspberrypi.nixosModules; [
    # ====== SYSTEM ======

    raspberry-pi-4.base
    raspberry-pi-4.bluetooth

    ../../modules/system/common.nix
    ../../modules/system/network/server.nix
    ../../modules/system/network/hosts.nix

    ../../modules/system/virtualization/host.nix

    ../../modules/system/nas/rpi4-f.nix
    ../../modules/system/nas/rpi5-k.nix

    ./hardware-configuration.nix
    ./disks.nix
    # TODO: ./rsync.nix

    # ====== APPS ======

    ../../modules/apps/editors/vim.nix

    ../../modules/apps/shells/fish.nix
    ../../modules/apps/shells/bash.nix

    ../../modules/apps/utils/eza
    ../../modules/apps/utils/macchina
    ../../modules/apps/utils/bat.nix
    ../../modules/apps/utils/btop.nix
    ../../modules/apps/utils/dust.nix
    ../../modules/apps/utils/fd.nix
    ../../modules/apps/utils/fzf.nix
    ../../modules/apps/utils/nh.nix
    ../../modules/apps/utils/starship.nix
    ../../modules/apps/utils/zoxide.nix

    # ====== SERVICES ======

    ../../modules/system/services/builders/builder.nix
    ../../modules/system/services/builders/distributed.nix

    # ../../modules/system/services/srv-utils/nix-serve.nix
    ../../modules/system/services/srv-utils/avahi.nix
    ../../modules/system/services/srv-utils/openssh.nix
    ../../modules/system/services/srv-utils/smb.nix

    ../../modules/system/services/web-utils/grocy.nix

    ../../modules/system/services/monitoring/prometheus.nix
  ];

  # =======================================================

  nix.settings = {
    substituters = [
      "https://nixos-raspberrypi.cachix.org"
      "http://192.168.88.252:5000"
    ];
    trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  nixpkgs.config.allowUnfree = false;
  system.stateVersion = "${stateVersion}";

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["ru_RU.UTF-8/UTF-8"];

  # =======================================================

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "end0";
      WIFI_IFACE = "wlan0";
      SSID = "rpi4-f-wifi";
      PASSPHRASE = "someveryinsecurepassword";
    };
  };

  services.borgbackup.jobs = {
    persist = {
      paths = ["/zroot/ldata/persist/rpi4-f"];
      repo = "optizone@ntt:/zroot/ldata/backups/rpi4-f";
      encryption.mode = "none";
      # encryption = {
      #   mode = "repokey-blake2";
      #   passCommand = "cat ${config.sops.secrets."borg/repo-pass/thinkpad".path}";
      # };
      environment.BORG_RSH = "ssh -i /zroot/ldata/secrets/thinkpad";
      compression = "none"; # btrfs compression is enabled
      startAt = "daily";
    };
  };

  # =======================================================

  networking.hostName = "${host}";
  networking.hostId = "${hostId}";

  sops.secrets."user-pass-hash/${host}".neededForUsers = true;
  sops.secrets."root-pass-hash/${host}".neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets."root-pass-hash/${host}".path;
  users.users.${username}.hashedPasswordFile = config.sops.secrets."user-pass-hash/${host}".path;

  boot.loader.raspberry-pi.bootloader = "uboot";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.nixos.tags = let
    cfg = config.boot.loader.raspberry-pi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

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
