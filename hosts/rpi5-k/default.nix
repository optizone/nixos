{
  pkgs,
  config,
  nixos-raspberrypi,
  username,
  host,
  ...
}:
{
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
    ];
    trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ru_RU.UTF-8/UTF-8" ];

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
    ];
  };

  # =======================================================

  sops.secrets."${host}/user-pass-hash".neededForUsers = true;
  sops.secrets."${host}/root-pass-hash".neededForUsers = true;

  users.users = {
    root.hashedPasswordFile = config.sops.secrets."${host}/root-pass-hash".path;
    ${username}.hashedPasswordFile = config.sops.secrets."${host}/user-pass-hash".path;
  };

  boot.loader.raspberry-pi.bootloader = "kernel";
  hardware.raspberry-pi.extra-config = ''
    dtparam=pciex1
    dtparam=pciex1_gen=3
  '';

  system.nixos.tags =
    let
      cfg = config.boot.loader.raspberry-pi;
    in
    [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];
}
