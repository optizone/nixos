{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        # Dependencies for compile and dev time
        nativeBuildInputs = with pkgs; [
          pkg-config
          sipp
          gdb
          uv
          cmake
          lksctp-tools
          libxcrypt
          libtool_1_5
          automake
          autoconf
          flex
          bison

          (python311.withPackages (pp: [
            pp.click
            pp.requests
            pp.distutils
          ]))
        ];

        # Dependencies for runtime
        buildInputs = with pkgs; [
          perl
          webrtc-audio-processing_0_3
          libopus
          libuuid
          curl
          zlib
          libpcap
          libxml2
          openssl
          gtest
          boost179
          alsa-lib
        ];
      in
        with pkgs; {
          devShells.default = mkShell {
            inherit buildInputs nativeBuildInputs;
            LD_LIBRARY_PATH = "/nix/store/al9x8cr5xifp3qd2f5cdzh6z603kb5ps-perl-5.40.0/lib/perl5/5.40.0/x86_64-linux-thread-multi/CORE/";
          };
        }
    );
}
