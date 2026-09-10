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

          BUILD_DIR = "../../../builds/l37balancer";

          # ========== SCRIPTS ==========

          build = pkgs.writeShellScriptBin "build" (builtins.readFile ./tools/scripts/build.sh);
          attach = pkgs.writeShellScriptBin "attach-docker" (builtins.readFile ./tools/scripts/attach-docker.sh);
          cp-artifacts = pkgs.writeShellScriptBin "cp-artifacts" (builtins.readFile ./tools/scripts/cp-docker-artifacts.sh);
          run-test = pkgs.writeShellScriptBin "run-test" ''
            build

            docker run --rm \
                -v l37balancer-build-volume:/build/l37balancer \
                --mount type=bind,src=.,dst=/sources/l37balancer \
                -w /sources/l37balancer \
                git.protei.ru:8443/docker/images/astra-18-build:latest \
                sh -c '/build/l37balancer/parts/l37balancer/install/bin/test_config'
          '';

          cp-to-deploy = pkgs.writeShellScriptBin "cp-to-deploy" ''
            build
            cp-artifacts ../balancer-deploy/src/balancer_deploy/balancer/tetrabl
          '';

          update-compile-commands = pkgs.writeShellScriptBin "update-compile-commands" ''
            build --local
            echo "Copying 'compile_commands.json'..."
            cp $BUILD_DIR/parts/l37balancer/build/compile_commands.json .
            echo "Done!"
          '';

          install-prettier-plugins = pkgs.writeShellScriptBin "install-prettier-plugins" ''
            ${pkgs.nodejs}/bin/npm i -D prettier prettier-plugin-sh
          '';

          scripts = [
            cp-to-deploy
            run-test
            build
            attach
            update-compile-commands
            install-prettier-plugins
            cp-artifacts
          ];

          # =========== DEPS ============

          # Dependencies for compile and dev time
          nativeBuildInputs = with pkgs; [
            gdb

            pkg-config
            pkgs-cmake-3-22.cmake
            pkgsStatic.icu.static
            pkgsStatic.icu.dev
            # pkgsStatic.zlib.static
            pkgsStatic.zlib.dev
            (xz.override {enableStatic = true;})

            (openssl.override {static = true;})
            (libxml2.override {version = "2.9.14";}).dev
            (pkgsStatic.libxml2.override {version = "2.9.14";}).dev
            glibc.static
            (zstd.override {static = true;}).dev
            pkgsStatic.libuuid.dev
            pkgsStatic.libuuid.lib

            lksctp-tools

            clang-tools

            (python311.withPackages (pp: [
              pp.click
              pp.requests
              pp.distutils
              pp.grpcio
              pp.grpcio-tools
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

          packages = scripts;

          # =============================
        };
      }
    );
}
