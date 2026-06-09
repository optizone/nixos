{
  lib,
  nixpkgs,
  config,
  system,
  host,
  hostId,
  username,
  stateVersion,
  ...
}:
let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = false;
    overlays = [
      (final: prev: {
        ubootOrangePiZero2W = prev.buildUBoot {
          defconfig = "orangepi_zero2w_defconfig";
          extraMeta.platforms = [ "aarch64-linux" ];
          filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
          version = "2024.04";
          src = prev.fetchurl {
            url = "https://ftp.denx.de/pub/u-boot/u-boot-2024.04.tar.bz2";
            hash = "sha256-GKhT/jn6160DqQzC1Cda6u1tppc13vrDSSuAUIhD3Uo=";
          };

          nativeBuildInputs = [
            prev.dtc
            prev.armTrustedFirmwareTools
            prev.bison
            prev.flex
            prev.which
            prev.swig
            prev.openssl

            (prev.python3.withPackages (p: [
              p.setuptools
              p.libfdt
              p.pyelftools
            ]))
          ];

          BL31 = "${prev.armTrustedFirmwareAllwinner}/bl31.bin";
        };
      })
    ];
  };
in
{
  # =======================================================

  imports = [
    ../../core/znode.nix

    ./disks.nix
    # ./hardware-configuration.nix

    ../../core/services/srv-utils/openssh.nix

    ../../home/flavours/nixos-module.nix
  ];

  # =======================================================

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "http://192.168.88.252:5000"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  nixpkgs.config.allowUnfree = false;
  system.stateVersion = "${stateVersion}";

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ru_RU.UTF-8/UTF-8" ];

  # =======================================================

  environment.systemPackages = with pkgs; [
    vim
    htop
  ];

  home-manager.users.${username} = {
    imports = [
      ../../home/headless.nix
      ../../home/terminal/apps/starship.nix
      ../../home/terminal/shells/bash.nix
    ];
  };

  # =======================================================

  networking.hostName = "${host}";
  networking.hostId = "${hostId}";

  sops.secrets."${host}/user-pass-hash".neededForUsers = true;
  sops.secrets."${host}/root-pass-hash".neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets."${host}/root-pass-hash".path;
  users.users.${username}.hashedPasswordFile = config.sops.secrets."${host}/user-pass-hash".path;

  # Pinned to 6.12 to avoid ZFS breakage
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    supportedFilesystems = lib.mkForce [
      "vfat"
      "ext4"
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    kernelParams = [ "console=ttyS0,115200" ];
  };

  hardware.deviceTree.name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";

  sdImage = {
    compressImage = true;
    postBuildCommands = ''
      dd if=${pkgs.ubootOrangePiZero2W}/u-boot-sunxi-with-spl.bin of=$img bs=1024 seek=8 conv=notrunc
    '';
  };
}
