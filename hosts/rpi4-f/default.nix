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
    ./backup.nix

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

    # ../../modules/system/services/utils/nix-serve.nix
    ../../modules/system/services/utils/avahi.nix
    ../../modules/system/services/utils/openssh.nix
    ../../modules/system/services/utils/smb.nix
    ../../modules/system/services/utils/borg-serve.nix

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

  # =======================================================

  networking.hostName = "${host}";
  networking.hostId = "${hostId}";

  sops.secrets."user-pass-hash/${host}".neededForUsers = true;
  sops.secrets."root-pass-hash/${host}".neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets."root-pass-hash/${host}".path;
  users.users.${username}.hashedPasswordFile = config.sops.secrets."user-pass-hash/${host}".path;

  boot.loader.raspberry-pi.bootloader = "uboot";

  system.nixos.tags = let
    cfg = config.boot.loader.raspberry-pi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}
