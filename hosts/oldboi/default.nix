{
  username,
  config,
  host,
  hostId,
  inputs,
  pkgs,
  ...
}: {
  # =======================================================

  imports = [
    # ====== SYSTEM ======
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
    ../../modules/apps/utils/wiki/man.nix
    ../../modules/apps/utils/wiki/tldr.nix
    ../../modules/apps/utils/wiki/wikiman.nix
    ../../modules/apps/utils/bat.nix
    ../../modules/apps/utils/btop.nix
    ../../modules/apps/utils/dust.nix
    ../../modules/apps/utils/fd.nix
    ../../modules/apps/utils/fzf.nix
    ../../modules/apps/utils/starship.nix
    ../../modules/apps/utils/zoxide.nix

    # ====== SERVICES ======

    ../../modules/system/services/builders/builder.nix
    ../../modules/system/services/builders/distributed.nix

    # ../../modules/system/services/media/immich.nix
    # ../../modules/system/services/srv-utils/nix-serve.nix
    ../../modules/system/services/srv-utils/avahi.nix
    ../../modules/system/services/srv-utils/openssh.nix
    ../../modules/system/services/srv-utils/smb.nix

    ../../modules/system/services/monitoring/prometheus.nix
    ../../modules/system/services/monitoring/smartd.nix
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

  services.v2raya.enable = true;

  services.ollama = {
    enable = true;
    package =
      (import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
      }).ollama-vulkan;

    host = "[::]";
    port = 11434;
    openFirewall = true;

    loadModels = ["qwen3.8:27b"];

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "64000";
      OLLAMA_VULKAN = "1";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 root root"
  ];

  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      {
        directory = "/var/lib/private/ollama";
        user = "nobody";
        group = "nogroup";
      }
    ];
  };

  # =======================================================

  services.smartd.devices = [{device = "/dev/sda";}];

  networking.hostName = "${host}";

  networking.hostId = "${hostId}";

  sops.secrets."user-pass-hash/${host}".neededForUsers = true;
  sops.secrets."root-pass-hash/${host}".neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets."root-pass-hash/${host}".path;
  users.users.${username}.hashedPasswordFile = config.sops.secrets."user-pass-hash/${host}".path;

  # # TODO: move to a module
  # systemd.tmpfiles.rules = [
  #   "d /zroot 0750 ${username} users"
  #
  #   "d /zroot/ldata 0750 ${username} users"
  #   "d /zroot/ldata/backups 0750 ${username} users"
  #   "d /zroot/ldata/builds 0750 ${username} users"
  #   "d /zroot/ldata/code 0750 ${username} users"
  #   "d /zroot/ldata/disk-images 0750 ${username} users"
  #   "d /zroot/ldata/media 0750 ${username} users"
  #   "d /zroot/ldata/secrets 0750 ${username} users"
  #   "d /zroot/ldata/wiki 0750 ${username} users"
  #   "d /zroot/ldata/persist 0750 ${username} users"
  #
  #   "d /zroot/nas 0750 ${username} users"
  #   "d /zroot/shuttles 0750 ${username} users"
  #   "d /zroot/notes 0750 ${username} users"
  #
  #   # NOTE: for future
  #   "L /home/${username}/zroot - - - - /zroot"
  #
  #   # FIXME: shuttles
  # ];
}
