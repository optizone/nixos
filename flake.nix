{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    wallpapers = {
      url = "git+file:wallpapers";
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

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # ============ RaspberryPi related inputs ============

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
    # ====================================================
  };

  outputs =
    {
      nixpkgs,
      self,
      nix-index-database,
      home-manager,
      home-manager-rpi,
      nixos-raspberrypi,
      disko-rpi,
      impermanence,
      sops-nix,
      sops-nix-rpi,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # font = "JetBrainsMono Nerd Font";
      # fontMono = "${font} Mono";
      font = "BigBlueTermPlus Nerd Font";
      fontMono = "${font} Mono";
      shell = pkgs.fish;

      gitUsername = "optizone";
      gitEmail = "ilya.kek.lol.orbidol@gmail.com";

      domain = "home.arpa";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {
        protei = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            gitUsername = "boicov";
            gitEmail = "boicov@protei.ru";
            username = "boicov";

            inherit
              self
              inputs
              font
              fontMono
              shell
              ;
          };

          modules = [ ./home/flavours/standalone.nix ];
        };
      };

      nixosConfigurations = {
        rpi5-k = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixos-raspberrypi domain;
            username = "rpi5-k";
            host = "rpi5-k";
            hostId = "deadb33f";
            stateVersion = "25.11";
            shell = pkgs.bash;
          };

          modules = [
            ./hosts/rpi5-k
            sops-nix-rpi.nixosModules.sops
            disko-rpi.nixosModules.disko
            impermanence.nixosModules.impermanence
            home-manager-rpi.nixosModules.home-manager
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/thinkpad
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
          ];
          specialArgs = {
            host = "thinkpad";
            username = "thinkpad";
            stateVersion = "24.05";
            inherit
              self
              inputs
              font
              fontMono
              shell
              gitUsername
              gitEmail
              ;
          };
        };

        generic-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/generic/laptop.nix
            nix-index-database.nixosModules.nix-index
          ];
          specialArgs = {
            host = "generic-laptop";
            username = "laptop-user";
            stateVersion = "25.11";
            inherit
              self
              inputs
              font
              fontMono
              shell
              gitUsername
              gitEmail
              ;
          };
        };

        generic-pc = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/generic/pc.nix
            nix-index-database.nixosModules.nix-index
          ];
          specialArgs = {
            host = "generic-pc";
            username = "pc-user";
            stateVersion = "25.11";
            inherit
              self
              inputs
              font
              fontMono
              shell
              gitUsername
              gitEmail
              ;
          };
        };
      };
    };
}
