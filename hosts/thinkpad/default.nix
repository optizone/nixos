{
  username,
  pkgs,
  inputs,
  config,
  ...
}: {
  # =======================================================

  imports = [
    # ====== SYSTEM ======
    ../../modules/system/common.nix
    ../../modules/system/network/laptop.nix
    ../../modules/system/network/hosts.nix
    ../../modules/system/pipewire.nix

    ../../modules/system/virtualization/host.nix

    ../../modules/system/nas/oldboi.nix
    ../../modules/system/nas/ntt.nix
    ../../modules/system/nas/rpi4-f.nix
    ../../modules/system/nas/rpi5-k.nix
    ../../shuttles

    ./hardware-configuration.nix
    # ./disks.nix
    ./rsync.nix

    # ====== DESKTOP ======

    ../../modules/desktops/hyprland

    # ====== APPS ======

    ../../modules/apps/bundles/common.nix

    ../../modules/apps/browsers/qutebroser.nix
    ../../modules/apps/browsers/google-chrome.nix
    ../../modules/apps/browsers/librewolf.nix

    ../../modules/apps/editors/neovim
    ../../modules/apps/editors/vim.nix

    ../../modules/apps/file-managers/yazi

    ../../modules/apps/multimedia/rmpc
    ../../modules/apps/multimedia/gimp.nix
    ../../modules/apps/multimedia/inkscape.nix
    ../../modules/apps/multimedia/kdenlive.nix
    ../../modules/apps/multimedia/mpv.nix
    ../../modules/apps/multimedia/oculante.nix
    ../../modules/apps/multimedia/spotify.nix
    ../../modules/apps/multimedia/steam.nix
    ../../modules/apps/multimedia/transmission.nix
    ../../modules/apps/multimedia/utils.nix

    ../../modules/apps/office/libreoffice.nix

    ../../modules/apps/shells/fish.nix
    ../../modules/apps/shells/bash.nix
    ../../modules/apps/shells/nushell.nix

    ../../modules/apps/social/telegram.nix
    ../../modules/apps/social/thunderbird.nix

    ../../modules/apps/terminals/kitty/default.nix

    ../../modules/apps/manufacturing/blender.nix
    ../../modules/apps/manufacturing/freecad.nix
    ../../modules/apps/manufacturing/kicad.nix
    ../../modules/apps/manufacturing/orca-slicer.nix

    ../../modules/apps/utils/eza
    ../../modules/apps/utils/fastfetch
    ../../modules/apps/utils/macchina
    ../../modules/apps/utils/pyobd/pyobd.nix
    ../../modules/apps/utils/scripts
    ../../modules/apps/utils/wiki/kiwix.nix
    ../../modules/apps/utils/wiki/man.nix
    ../../modules/apps/utils/wiki/tldr.nix
    ../../modules/apps/utils/wiki/wikiman.nix
    ../../modules/apps/utils/wiki/zeal.nix
    ../../modules/apps/utils/ai.nix
    ../../modules/apps/utils/bat.nix
    ../../modules/apps/utils/btop.nix
    ../../modules/apps/utils/calcure.nix
    ../../modules/apps/utils/caligula.nix
    ../../modules/apps/utils/dust.nix
    ../../modules/apps/utils/electrum.nix
    ../../modules/apps/utils/fd.nix
    ../../modules/apps/utils/fzf.nix
    ../../modules/apps/utils/git.nix
    ../../modules/apps/utils/kanshi.nix
    ../../modules/apps/utils/lazygit.nix
    ../../modules/apps/utils/nh.nix
    ../../modules/apps/utils/pastel.nix
    ../../modules/apps/utils/ssh.nix
    ../../modules/apps/utils/starship.nix
    ../../modules/apps/utils/wireshark.nix
    ../../modules/apps/utils/waypaper.nix
    ../../modules/apps/utils/zoxide.nix

    ../../modules/meshtastic

    # ====== SERVICES ======

    ../../modules/system/services/builders/distributed.nix

    ../../modules/system/services/web-utils/lubelogger.nix
    ../../modules/system/services/srv-utils/paperless.nix
    ../../modules/system/services/media/mpd.nix
    ../../modules/system/services/srv-utils/nix-serve.nix
    ../../modules/system/services/srv-utils/avahi.nix
    ../../modules/system/services/web-utils/actual.nix

    ../../modules/system/services/monitoring/grafana.nix
    ../../modules/system/services/monitoring/prometheus.nix
    ../../modules/system/services/monitoring/smartd.nix
    ../../modules/system/services/monitoring/wakapi.nix
  ];

  # =======================================================

  # TODO: move to a module
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];

    keep-outputs = true;
    keep-derivations = true;
  };

  nixpkgs.config.allowUnfree = true;

  # =======================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["ru_RU.UTF-8/UTF-8"];

  # =======================================================

  # TODO: move to a module
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      zeal
      (timr-tui.override {enableSound = true;})
      blender
      otpclient
      iperf
      nix-inspect
      ffmpeg
      nixos-anywhere
      just
      nixos-rebuild-ng
      htop
      disko
      ssh-to-age
      sops
      gh
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };
    };
  };

  services = {
    v2raya.enable = true;
    radarr.enable = true;
  };

  programs = {
    winbox = {
      enable = true;
      openFirewall = true;
    };
  };

  # =======================================================

  # HACK: needed for impermanence
  fileSystems."/home".neededForBoot = true;

  hardware = {
    cpu.intel.npu.enable = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics = {
      enable = true;
      package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa;

      extraPackages = with pkgs; [
        intel-media-driver
        (intel-vaapi-driver.override {enableHybridCodec = true;})
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    enableRedistributableFirmware = true;
  };

  services = {
    blueman.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";
  };

  services.smartd = {
    devices = [
      {device = "/dev/nvme0";}
    ];
  };

  users.users.${username} = {
    extraGroups = [
      "dialout" # socat??
      "tty" #??
    ];
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

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
