{
  pkgs,
  config,
  nixos-raspberrypi,
  username,
  host,
  ...
}: {
  # =======================================================

  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.bluetooth

    ../../core/znode.nix

    ./disks.nix
    ./hardware-configuration.nix
    ./nginx.nix

    ../../core/services/srv-utils/smb.nix
    ../../core/services/srv-utils/nfs.nix
    ../../core/services/srv-utils/openssh.nix
    ../../core/services/srv-utils/adguard.nix

    ../../core/services/media/jellyfin.nix

    ../../core/services/web-utils/grocy.nix

    ../../core/services/iot/zigbee2mqtt.nix
    ../../core/services/iot/mqtt.nix
    ../../core/services/iot/matter.nix
    ../../core/services/iot/home-assistant.nix

    ../../home/flavours/nixos-module.nix
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

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["ru_RU.UTF-8/UTF-8"];

  # =======================================================

  environment.systemPackages = with pkgs; [
    vim
    htop
    iotop
    iperf
    lsof
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/headless.nix
      ../../home/terminal/apps/starship.nix
      ../../home/terminal/shells/bash.nix
      ../../home/terminal/shells/fish.nix

      ../../home/terminal/apps/eza
      ../../home/terminal/apps/fd.nix
      ../../home/terminal/apps/dust.nix
      ../../home/terminal/apps/yazi
      ../../home/terminal/apps/bat.nix
      ../../home/terminal/apps/fzf.nix
      ../../home/terminal/apps/starship.nix
      ../../home/terminal/apps/zoxide.nix
    ];
  };

  # =======================================================

  sops.secrets."user-pass-hash/${host}".neededForUsers = true;
  sops.secrets."root-pass-hash/${host}".neededForUsers = true;

  users.users = {
    root.hashedPasswordFile = config.sops.secrets."root-pass-hash/${host}".path;
    ${username}.hashedPasswordFile = config.sops.secrets."user-pass-hash/${host}".path;
  };

  boot.loader.raspberry-pi.bootloader = "kernel";
  hardware.raspberry-pi.extra-config = ''
    dtparam=pciex1
    dtparam=pciex1_gen=3
  '';

  system.nixos.tags = let
    cfg = config.boot.loader.raspberry-pi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}
