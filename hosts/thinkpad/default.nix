{
  username,
  pkgs,
  stateVersion,
  ...
}:
{
  # =======================================================

  imports = [
    ../../core
    ../../core/laptop.nix
    ./hardware-configuration.nix

    ../../home/flavours/nixos-module.nix
    ../../core/virtualization/host.nix

    ../../core/services/web-utils/lubelogger.nix
    ../../core/services/media/mpd.nix

    ./rsync.nix
    ./smb-rpi5-k.nix
  ];

  # =======================================================

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "${stateVersion}";

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ru_RU.UTF-8/UTF-8" ];

  # =======================================================

  programs.winbox = {
    enable = true;
    openFirewall = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  home-manager.users.${username} = {
    imports = [
      ../../home
      ../../home/gui-apps/utils/pyobd/pyobd.nix
    ];
  };

  # =======================================================

  users.users.${username} = {
    extraGroups = [
      "wireshark"
      "dialout"
      "tty"
    ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hosts = {
    "192.168.68.118" = [ "rpi5-k" ];
  };

  # needed for MKD2 work project
  systemd.tmpfiles.rules = [
    "d /var/run/protei-config-manager 0777 ${username} users"
  ];
}
