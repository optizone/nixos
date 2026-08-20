{
  inputs = {
    # ====================== System =======================

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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
      url = "github:nix-community/home-manager/release-25.11";
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

  outputs = {
    nixpkgs,
    self,
    nix-index-database,
    home-manager,
    home-manager-rpi,
    nixos-raspberrypi,
    disko-rpi,
    disko,
    impermanence,
    sops-nix,
    sops-nix-rpi,
    ...
  } @ inputs: let
    domain = "home.arpa";
    username = "optizone";

    # font = "JetBrainsMono Nerd Font";
    font = "BigBlueTermPlus Nerd Font";
    fontMono = "${font} Mono";
    fontSize = 13;

    gitUsername = "optizone";
    gitEmail = "ilya.kek.lol.orbidol@gmail.com";

    pkgs-x86 = import nixpkgs {
      system = "x86_64-linux";
    };

    pkgs-arm = import nixpkgs {
      system = "aarch64-linux";
    };
  in {
    homeConfigurations = {
      protei = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-x86;

        extraSpecialArgs = {
          gitUsername = "boicov";
          gitEmail = "boicov@protei.ru";
          username = "boicov";
          shell = pkgs-x86.fish;

          inherit
            self
            inputs
            font
            fontMono
            ;
        };

        modules = [./home/flavours/standalone.nix];
      };
    };

    nixosConfigurations = {
      # ==== ARM ====

      # NAS + services

      rpi5-k = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            username
            nixos-raspberrypi
            domain
            ;
          host = "rpi5-k";
          hostId = "d100d000";
          stateVersion = "25.11";
          shell = pkgs-arm.fish;
        };

        modules = [
          ./hosts/rpi5-k
          sops-nix-rpi.nixosModules.sops
          disko-rpi.nixosModules.disko
          impermanence.nixosModules.impermanence
          home-manager-rpi.nixosModules.home-manager
        ];
      };

      # RnD

      rpi4-f = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            username
            nixos-raspberrypi
            domain
            ;
          host = "rpi4-f";
          hostId = "d101d000";
          stateVersion = "25.11";
          shell = pkgs-arm.fish;
        };

        modules = [
          ./hosts/rpi4-f
          sops-nix-rpi.nixosModules.sops
          disko-rpi.nixosModules.disko
          impermanence.nixosModules.impermanence
          home-manager-rpi.nixosModules.home-manager
        ];
      };

      # FIXME: does not build
      opi2-c = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit
            inputs
            username
            domain
            ;
          host = "opi2-c";
          hostId = "d101d001";
          stateVersion = "26.05";
          shell = pkgs-arm.fish;
        };

        modules = [
          ./hosts/opi2-c
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
        ];
      };

      # ==== x86-64 ====

      # Personal

      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/thinkpad
          nix-index-database.nixosModules.nix-index
          {
            programs.nix-index-database.comma.enable = true;
          }
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
        ];
        specialArgs = {
          host = "thinkpad";
          username = "thinkpad";
          stateVersion = "24.05";
          shell = pkgs-x86.fish;

          inherit
            self
            inputs
            domain
            font
            fontMono
            fontSize
            gitUsername
            gitEmail
            ;
        };
      };

      # ==== VMs ====

      # RnD

      vm0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/vm0
          nix-index-database.nixosModules.nix-index
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
        ];

        specialArgs = {
          host = "vm0";
          stateVersion = "25.11";
          shell = pkgs-x86.fish;

          inherit
            self
            inputs
            font
            fontMono
            gitUsername
            gitEmail
            ;
        };
      };

      # === Generic x86-64 ===

      generic-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/generic/laptop.nix
          nix-index-database.nixosModules.nix-index
        ];
        specialArgs = {
          host = "generic-laptop";
          username = "laptop-user";
          stateVersion = "25.11";
          shell = pkgs-x86.fish;

          inherit
            self
            inputs
            font
            fontMono
            gitUsername
            gitEmail
            ;
        };
      };

      generic-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/generic/pc.nix
          nix-index-database.nixosModules.nix-index
        ];
        specialArgs = {
          host = "generic-pc";
          username = "pc-user";
          stateVersion = "25.11";
          shell = pkgs-x86.fish;

          inherit
            self
            inputs
            font
            fontMono
            gitUsername
            gitEmail
            ;
        };
      };
    };
  };
}
