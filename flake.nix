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
  };

  outputs =
    {
      nixpkgs,
      self,
      nix-index-database,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      font = "JetBrainsMono Nerd Font";
      fontMono = "${font} Mono";
      shell = pkgs.fish;

      gitUsername = "optizone";
      gitEmail = "ilya.kek.lol.orbidol@gmail.com";

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
        thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/thinkpad
            nix-index-database.nixosModules.nix-index
          ];
          specialArgs = {
            host = "thinkpad";
            username = "thinkpad";
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
