{ username, lib, ... }:
{
  # =======================================================

  imports = [
    ../../core
    ../../core/laptop.nix
    ./hardware-configuration.nix

    ../../home/flavours/nixos-module.nix

    ../../core/services/lubelogger.nix
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
  system.stateVersion = "24.05";
  home-manager.users.${username}.home.stateVersion = lib.mkForce "24.05";

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ru_RU.UTF-8/UTF-8" ];

  # =======================================================

  programs.winbox = {
    enable = true;
    openFirewall = true;
  };

  # =======================================================

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
