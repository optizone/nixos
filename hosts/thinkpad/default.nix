{
  username,
  pkgs,
  config,
  ...
}: {
  # =======================================================

  imports = [
    ../../core/laptop.nix
    ../../core/virtualization/host.nix
    ../../core/programs/steam.nix

    ./hardware-configuration.nix

    ../../core/services/web-utils/lubelogger.nix
    ../../core/services/srv-utils/paperless.nix
    ../../core/services/media/mpd.nix
    ../../core/services/srv-utils/nix-serve.nix
    ../../core/services/srv-utils/monitoring.nix
    ../../core/services/srv-utils/avahi.nix
    ../../core/services/web-utils/actual.nix

    ../../home/flavours/nixos-module.nix

    ../../core/meshtastic

    ./rsync.nix
    ./smb-rpi5-k.nix
    ./smb-rpi4-f.nix
    ../../shuttles
  ];

  # =======================================================

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

  home-manager.users.${username} = {
    imports = [
      ../../home/default.nix
      ../../home/gui-apps/utils/pyobd/pyobd.nix
    ];

    home.packages = with pkgs; [
      zeal
      blender
      otpclient
      iperf
      ffmpeg
      nixos-anywhere
      just
      nushell
      nixos-rebuild-ng
      htop
      disko
      ssh-to-age
      sops
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

    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  environment.systemPackages = with pkgs; [
    socat
    man-pages
    man-pages-posix
  ];

  documentation.man.cache.enable = true;
  documentation.dev.enable = true;

  # =======================================================

  hardware.cpu.intel.npu.enable = true;

  users.users.${username} = {
    extraGroups = [
      "wireshark"
      "dialout"
      "tty"
    ];
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.hosts = {
    "192.168.88.248" = ["rpi5-k"];
    "192.168.88.163" = ["rpi4-f"];
  };

  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "rpi5-k";
        system = "aarch64-linux,armv7l-linux,armv6l-linux";
        protocol = "ssh-ng";
        sshUser = "nixremotebuilder";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUJWWW9sY3U0SndkQXRZbUhIZzh5OUczb1RqYUtTSi9GUERCWERPdEpRM1cgcm9vdEBuaXhvcy1pbnN0YWxsZXIK";
        sshKey = "/home/thinkpad/.ssh/thinkpad";
        maxJobs = 3;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [];
      }

      {
        hostName = "rpi4-f";
        system = "aarch64-linux,armv7l-linux,armv6l-linux";
        protocol = "ssh-ng";
        sshUser = "nixremotebuilder";
        sshKey = "/home/thinkpad/.ssh/thinkpad";
        maxJobs = 3;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [];
      }
    ];
  };
}
