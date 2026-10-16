{
  username,
  config,
  host,
  hostId,
  ...
}: {
  # =======================================================

  imports = [
    # ====== SYSTEM ======

    ../../modules/system/common.nix
    ../../modules/system/bootloader/x86.nix
    ../../modules/system/network/server.nix
    ../../modules/system/network/hosts.nix
    ../../modules/system/virtualization/guest.nix

    ./hardware-configuration.nix
    ./disks.nix

    # ====== APPS ======

    ../../modules/apps/editors/vim.nix

    ../../modules/apps/shells/fish.nix
    ../../modules/apps/shells/bash.nix

    ../../modules/apps/utils/eza
    ../../modules/apps/utils/macchina
    ../../modules/apps/utils/nh.nix
    ../../modules/apps/utils/starship.nix

    # ====== SERVICES ======

    ../../modules/system/services/srv-utils/avahi.nix
    ../../modules/system/services/srv-utils/openssh.nix
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

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["ru_RU.UTF-8/UTF-8"];

  # =======================================================

  # =======================================================

  networking.hostName = "${host}";
  networking.hostId = "${hostId}";

  sops.secrets."user-pass-hash/${host}".neededForUsers = true;
  sops.secrets."root-pass-hash/${host}".neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets."root-pass-hash/${host}".path;
  users.users.${username}.hashedPasswordFile = config.sops.secrets."user-pass-hash/${host}".path;
}
