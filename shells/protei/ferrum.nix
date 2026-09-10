{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustVersion = "1.85.1";
        rust = pkgs.rust-bin.stable.${rustVersion}.minimal.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
            "clippy"
          ];
        };

        # Dependencies for compile and dev time
        nativeBuildInputs = with pkgs; [
          rust
          pkg-config
          openssl
          (rustfmt.override { asNightly = true; })
          sqlx-cli
          sipp
          cmake
        ];

        # Dependencies for runtime
        buildInputs = with pkgs; [
          redis
          protobuf
          lksctp-tools
          c-ares
          sqlite
        ];
      in
      with pkgs;
      {
        devShells.default = mkShell {
          inherit buildInputs nativeBuildInputs;
        };
      }
    );
}
