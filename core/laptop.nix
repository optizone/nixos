{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./graphics

    ./system/bootloader.nix
    ./system/network/laptop.nix
    ./system/settings.nix
    ./system/pipewire.nix
    ./system/security.nix
    ./system/sops.nix

    ./programs/nh.nix
  ];

  services = {
    gvfs.enable = true;
    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };
    dbus.enable = true;
    fstrim.enable = true;

    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];
  };

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    powertop
  ];

  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "ignore";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services = {
    blueman.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";

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

      # TODO: gives an error about bad val or fraction
      INTEL_GPU_MIN_FREQ_ON_AC = 200;
      INTEL_GPU_MIN_FREQ_ON_BAT = 200;

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
