{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-cmake.url = "https://github.com/NixOS/nixpkgs/archive/f76bef61369be38a10c7a1aa718782a60340d9ff.tar.gz";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nixpkgs-cmake,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs-cmake-3-22 = import nixpkgs-cmake {inherit system;};
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells.default = pkgs.mkShell rec {
          # ============ ENV ============

          SG_TESTER_BUILD_TESTS = "ON";
          SG_TESTER_RPC_BUILD_TESTS = "ON";
          BUILD_DIR = "../../../builds/sgtester";

          # ========== SCRIPTS ==========

          build = pkgs.writeShellScriptBin "build" (builtins.readFile ./tools/scripts/build.sh);

          update-compile-commands = pkgs.writeShellScriptBin "update-compile-commands" ''
            build --local
            echo "Copying 'compile_commands.json'..."
            cp $BUILD_DIR/parts/SgTester/build/compile_commands.json .
            echo "Done!"
          '';

          run-tests = pkgs.writeShellScriptBin "run-tests" (builtins.readFile ./tools/scripts/test.sh);

          install-prettier-plugins = pkgs.writeShellScriptBin "install-prettier-plugins" ''
            ${pkgs.nodejs}/bin/npm i -D prettier prettier-plugin-sh
          '';

          scripts = [
            build
            run-tests
            update-compile-commands
            install-prettier-plugins
          ];

          # =========== DEPS ============

          # Dependencies for compile and dev time
          nativeBuildInputs = with pkgs; [
            pkg-config
            sipp
            gdb
            uv
            pkgs-cmake-3-22.cmake
            lksctp-tools
            clang-tools
            prettier
            libxcrypt
            libtool_1_5
            automake
            autoconf
            flex
            bison
            abseil-cpp
            (python311.withPackages (pp: [
              pp.click
              pp.requests
              pp.distutils
            ]))
            gersemi
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

          packages = scripts;

          # =============================
        };
      }
    );
}
