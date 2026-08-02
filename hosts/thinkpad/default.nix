{
  username,
  pkgs,
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
    ../../core/services/srv-utils/avahi.nix
    ../../core/services/web-utils/actual.nix

    ../../home/flavours/nixos-module.nix

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
      ../../home/terminal/apps/contact.nix
    ];

    home.packages = with pkgs; [
      zeal
      iperf
      ffmpeg
      nixos-anywhere
      just
      nixos-rebuild-ng
      htop
      ollama-vulkan
      disko
      ssh-to-age
      sops

      (writeShellScriptBin "zai" ''
        # TODO: add usage check. arguments
        #   - <ACTION>: [ code chat pull ], default code
        #   - <MODEL>:
        #     if action == code then [ qwen3.6:35b gemma4:12b ], default qwen3.6:35b
        #     if action == chat then [ deepseek-r1:32b ], default deepseek-r1:32b
        #     if action == pull then all above, default all
        MODEL="$1"
        [ -z "$MODEL" ] && MODEL="ollama/gemma4:12b"


        echo "starting ollama..."
        # OLLAMA_VULKAN=1 OLLAMA_IGPU_ENABLE=1
        SERVER_PID=$(OLLAMA_CONTEXT_LENGTH=64000 ollama 2>&1 & echo $!)

        trap 'kill $SERVER_PID 2>/dev/null; wait $SERVER_PID || true' EXIT

        echo ""
        echo "starting opencode..."
        ollama launch opencode

        echo "waiting ollama serve to shutdown..."
        wait $SERVER_PID
      '')
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      opencode = {
        enable = true;
        tui.theme = "gruvbox";

        settings = {
          default_agent = "plan";

          autoupdate = false;
          provider.ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama";
            options = {
              baseURL = "http://127.0.0.1:11434/v1";
            };

            models = {
              "qwen3.6:35b" = {
                name = "qwen3.6:35b";
                reasoning = true;
                tools = true;
              };

              "gemma4:12b" = {
                name = "gemma4:12b";
                reasoning = true;
                tools = true;
              };

              "qwen3:0.6b" = {
                name = "qwen3:0.6b";
                reasoning = true;
                tools = true;
              };
            };
          };
        };
      };
    };
  };

  services.v2raya.enable = true;

  programs = {
    # throne = {
    #   enable = true;
    #   tunMode.enable = true;
    # };

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
    "192.168.88.219" = ["rpi4-f"];
  };

  # needed for MKD2 work project
  systemd.tmpfiles.rules = [
    "d /var/run/protei-config-manager 0777 ${username} users"
  ];

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
