{
  username,
  pkgs,
  ...
}:
{
  # =======================================================

  imports = [
    ../../core/laptop.nix
    ../../core/virtualization/host.nix
    ../../core/programs/steam.nix

    ./hardware-configuration.nix

    ../../core/services/web-utils/lubelogger.nix
    ../../core/services/media/mpd.nix

    ../../home/flavours/nixos-module.nix

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

    keep-outputs = true;
    keep-derivations = true;
  };

  nixpkgs.config.allowUnfree = true;

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ru_RU.UTF-8/UTF-8" ];

  # =======================================================

  services.v2raya.enable = true;

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
      ../../home/default.nix
      ../../home/gui-apps/utils/pyobd/pyobd.nix
    ];

  };

  environment.systemPackages = with pkgs; [
    socat
    iperf
    ffmpeg
    contact # mestasthic TUI

    man-pages
    man-pages-posix
  ];

  documentation.man.generateCaches = true;
  documentation.dev.enable = true;

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
