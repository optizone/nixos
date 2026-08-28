{
  config,
  nixos-raspberrypi,
  username,
  host,
  hostId,
  stateVersion,
  ...
}: {
  # =======================================================

  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-4.base
    raspberry-pi-4.bluetooth

    ../../core/znode.nix

    ./disks.nix
    ./hardware-configuration.nix

    ../../core/services/srv-utils/openssh.nix
    ../../core/services/srv-utils/avahi.nix
    ../../core/services/srv-utils/smb.nix
    ../../core/services/srv-utils/monitoring.nix

    ../../home/flavours/nixos-module.nix
    ../../shuttles
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

  home-manager.users.${username} = {
    imports = [
      ../../home/headless.nix
      ../../home/terminal/apps/starship.nix
      ../../home/terminal/shells/bash.nix
      ../../home/terminal/shells/fish.nix
      ../../home/terminal/apps/eza
      ../../home/terminal/apps/yazi
      ../../home/terminal/apps/bat.nix
      ../../home/terminal/apps/zoxide.nix
    ];
  };

  # =======================================================

  networking.hostName = "${host}";
  networking.hostId = "${hostId}";

  sops.secrets."${host}/user-pass-hash".neededForUsers = true;
  sops.secrets."${host}/root-pass-hash".neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets."${host}/root-pass-hash".path;
  users.users.${username}.hashedPasswordFile = config.sops.secrets."${host}/user-pass-hash".path;

  boot.loader.raspberry-pi.bootloader = "uboot";

  system.nixos.tags = let
    cfg = config.boot.loader.raspberry-pi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  systemd.tmpfiles.rules = [
    "d /zroot 0755 ${username} users"

    "d /zroot/ldata 0755 ${username} users"
    "d /zroot/ldata/backups 0755 ${username} users"
    "d /zroot/ldata/builds 0755 ${username} users"
    "d /zroot/ldata/code 0755 ${username} users"
    "d /zroot/ldata/disk-images 0755 ${username} users"
    "d /zroot/ldata/media 0755 ${username} users"
    "d /zroot/ldata/secrets 0755 ${username} users"
    "d /zroot/ldata/wiki 0755 ${username} users"
    "d /zroot/ldata/persist 0755 ${username} users"

    "d /zroot/nas 0755 ${username} users"
    "d /zroot/shuttles 0755 ${username} users"
    "d /zroot/notes 0755 ${username} users"

    # NOTE: for future
    "L /home/${username}/zroot - - - - /zroot"

    # FIXME: shuttles
  ];
}
