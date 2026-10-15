{
  inputs = {
    # ====================== System =======================

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ===================== Hyprland ======================

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    # ====================== NeoVim =======================

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.ndg.follows = "ndg";
    };

    ndg = {
      url = "github:feel-co/ndg";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ======================= Misc ========================

    self.submodules = true;
    wallpapers = {
      url = "git+file:assets/wallpapers";
      flake = false;
    };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==================== RaspberryPi ====================

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    home-manager-rpi = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    };

    sops-nix-rpi = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    };

    disko-rpi = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    };

    # =====================================================
  };

  outputs = inputs @ {self, ...}: let
    # ===================
    # ==== RPI HOSTS ====
    # ===================
    rpi-hosts = {
      # ==== NAS + services ====
      rpi5-k = {
        system = "aarch64-linux";
        hostId = "d100d000";
        stateVersion = "25.11";
      };

      # ==== RnD ====
      rpi4-f = {
        system = "aarch64-linux";
        hostId = "d101d000";
        stateVersion = "26.05";
      };
    };

    # ===============
    # ==== HOSTS ====
    # ===============
    hosts = {
      # ==== Workstation ====
      thinkpad = {
        system = "x86_64-linux";
        hostId = "d001d001";
        username = "thinkpad";
        stateVersion = "24.05";
      };

      # ==== NAS + services ====
      ntt = {
        system = "x86_64-linux";
        hostId = "d001d002";
        stateVersion = "26.05";
      };

      # ==== AI + services ====
      oldboi = {
        system = "x86_64-linux";
        hostId = "d001d003";
        stateVersion = "26.05";
      };

      # ==== WIP ====
      opi2-c = {
        system = "aarch64-linux";
        hostId = "d101d001";
        stateVersion = "26.05";
      };

      # === Generic ===
      generic-laptop = {
        system = "x86_64-linux";
        hostId = "00000000";
        username = "generic-user";
        gitUsername = "generic";
        gitEmail = "generic@generic.gen";
        stateVersion = "25.11";
      };

      # === Generic ===
      generic-pc = {
        system = "x86_64-linux";
        hostId = "00000000";
        username = "generic-user";
        gitUsername = "generic";
        gitEmail = "generic@generic.gen";
        stateVersion = "25.11";
      };
    };

    # ======================
    # ==== HOSTS SCHEMA ====
    # ======================
    host-options = lib.mkOption {
      description = "An attribute set of host definitions to be generated.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            username = lib.mkOption {
              type = lib.types.str;
              default = "optizone";
              description = "Primary user account name for this host.";
            };

            system = lib.mkOption {
              type = lib.types.str;
              default = "x86_64-linux";
              description = "The target system architecture.";
            };

            domain = lib.mkOption {
              type = lib.types.str;
              default = "home.arpa";
              description = "";
            };

            font = lib.mkOption {
              type = lib.types.str;
              default = "BigBlueTermPlus Nerd Font";
              description = "";
            };

            fontMono = lib.mkOption {
              type = lib.types.str;
              default = "BigBlueTermPlus Nerd Font Mono";
              description = "";
            };

            fontSize = lib.mkOption {
              type = lib.types.number;
              default = 13;
              description = "";
            };

            gitUsername = lib.mkOption {
              type = lib.types.str;
              default = "optizone";
              description = "";
            };

            gitEmail = lib.mkOption {
              type = lib.types.str;
              default = "ilya.kek.lol.orbidol@gmail.com";
              description = "";
            };

            stateVersion = lib.mkOption {
              type = lib.types.str;
              description = "";
            };

            hostId = lib.mkOption {
              type = lib.types.str;
              description = "";
            };
          };
        }
      );
    };

    # =================================
    # ==== COMMON HOST DEFINITIONS ====
    # =================================
    sys-config = host: cfg: modules: {
      specialArgs = {
        inherit
          inputs
          self
          host
          ;

        inherit
          (cfg)
          system
          stateVersion
          username
          domain
          font
          fontMono
          fontSize
          gitUsername
          gitEmail
          hostId
          ;
      };

      modules =
        [
          "${self}/hosts/${host}/default.nix"

          {
            users.users.${cfg.username} = {
              isNormalUser = true;
              description = "${cfg.username}";
              extraGroups = [
                "networkmanager" # TODO: move to module
                "users"
                "wheel"
                "${cfg.username}"
              ];
              shell =
                (import inputs.nixpkgs {
                  inherit (cfg) system;
                }).fish;
            };

            programs.fish.enable = true;

            nix.settings.allowed-users = ["${cfg.username}"];
            nix.settings.trusted-users = ["${cfg.username}"];

            nixpkgs.hostPlatform = cfg.system;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";

              users.${cfg.username} = {
                home = {
                  username = "${cfg.username}";
                  stateVersion = "${cfg.stateVersion}";
                };
                programs.home-manager.enable = true;
              };

              extraSpecialArgs = {
                inherit
                  inputs
                  host
                  ;
                inherit (cfg) username;
              };
            };
          }
        ]
        ++ modules;
    };

    lib = inputs.nixpkgs.lib;
  in {
    nixosConfigurations =
      # =========================
      # ==== DEFAULT FACTORY ====
      # =========================
      lib.mapAttrs (
        host: cfg:
          inputs.nixpkgs.lib.nixosSystem (sys-config host cfg [
            inputs.nix-index-database.nixosModules.nix-index
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.disko.nixosModules.disko
            inputs.impermanence.nixosModules.impermanence
          ])
      )
      (inputs.nixpkgs.lib.evalModules {
        modules = [
          {
            options.hosts = host-options;
            config.hosts = hosts;
          }
        ];
      }).config.hosts
      # =====================
      # ==== RPI FACTORY ====
      # =====================
      // lib.mapAttrs (
        host: cfg:
          inputs.nixos-raspberrypi.lib.nixosSystem (sys-config host cfg [
            inputs.nix-index-database.nixosModules.nix-index
            inputs.sops-nix-rpi.nixosModules.sops
            inputs.disko-rpi.nixosModules.disko
            inputs.impermanence.nixosModules.impermanence
            inputs.home-manager-rpi.nixosModules.home-manager
          ])
      )
      (inputs.nixpkgs.lib.evalModules {
        modules = [
          {
            options.hosts = host-options;
            config.hosts = rpi-hosts;
          }
        ];
      }).config.hosts;
  };
}
