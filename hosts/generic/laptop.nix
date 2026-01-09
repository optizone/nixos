{
  username,
  lib,
  config,
  pkgs,
  ...
}:
{
  # =======================================================

  imports = [
    ../../core
    ../../core/laptop.nix
    ./hardware-configuration.nix

    ../../home/flavours/nixos-module.nix
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

  # environment.systemPackages = with pkgs; [ ];

  # =======================================================

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "ignore";

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    powertop
  ];

  services = {
    tlp.enable = true;
    tlp.settings = {
      # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      # PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_AC = "low-power";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;

      STOP_CHARGE_THRESH_BAT0 = 1;

      START_CHARGE_THRESH_BAT1 = 75;
      STOP_CHARGE_THRESH_BAT1 = 80;

      # INTEL_GPU_MAX_FREQ_ON_AC=0;
      # INTEL_GPU_MAX_FREQ_ON_BAT=0;
      # INTEL_GPU_BOOST_FREQ_ON_AC=0;
      # INTEL_GPU_BOOST_FREQ_ON_BAT=0;

      # PCIE_ASPM_ON_AC = "default";
      # PCIE_ASPM_ON_BAT = "powersupersave";
    };
  };

  # powerManagement.cpuFreqGovernor = "performance";
  powerManagement.cpuFreqGovernor = "low-power";

  boot = {
    kernelModules = [
      "acpi_call"
      "thinkpad_acpi"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      cpupower
    ];
  };
}
