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

          FISH_INIT_SUPPRESS_FASTFETCH = "ON";
          BUILD_DIR = "../../../builds/ITG";
          BUILD_FILE = "./build_almaz.yaml";

          # ========== SCRIPTS ==========

          build-local = pkgs.writeShellScriptBin "build-local" ''
            [ -f metacraft.zip ] || wget -nc -O metacraft.zip ftp://backup.protei/metacraft/metacraft-latest.zip
            echo "BUILD_DIR=$BUILD_DIR"
            build_file="$1"
            echo "Building $build_file"
            python3 ./metacraft.zip "$build_file" -d $BUILD_DIR -j $(nproc)
          '';

          update-compile-commands = pkgs.writeShellScriptBin "update-compile-commands" ''
            build
            echo "Copying 'compile_commands.json'..."
            cp $BUILD_DIR/parts/SgTester/build/compile_commands.json .
            echo "Done!"
          '';

          build = pkgs.writeShellScriptBin "build" ''
            wget -nc -O metacraft.zip ftp://backup.protei/metacraft/metacraft-latest.zip
            [ "$1" == "--build-container" ] && docker build -t itg-builder ./tools/build/astra18
            docker run -v itg-build:/build/itg \
                --mount type=bind,src=../,dst=/sources \
                -w /sources/ITG \
                -e BUILD_FILE="$BUILD_FILE" \
                -it git.protei.ru:8443/docker/images/astra-18-build:latest \
                /bin/bash -c  '\
                   export PATH=/sources/makegen:$PATH &&\
                   export PROTEI_MAK_PATH=/sources/itg-r8/protei.mak &&\
                   export ATE_MAK_PATH=/sources/itg-r8/ATE.mak &&\
                   apt install uuid-dev && \
                   python3 metacraft.zip "$BUILD_FILE" -d /build/itg -j $(nproc)'
          '';

          attach = pkgs.writeShellScriptBin "attach" ''
            docker run -v itg-build:/build/itg \
                --mount type=bind,src=../,dst=/sources \
                -w /build/itg/usr/bin \
                -it itg-builder
          '';

          run = pkgs.writeShellScriptBin "run" ''
            [ "$1" == "--rebuild" ] && build
            docker run -v itg-build:/build/itg \
                --mount type=bind,src=../,dst=/sources \
                -w /sources/ITG \
                -it itg-builder \
                cp -rf ./config/test/config/ /build/itg/usr/bin
            docker run -v itg-build:/build/itg \
                --mount type=bind,src=../,dst=/sources \
                -w /build/itg/usr/bin \
                -p 12345:12345 \
                -it itg-builder \
                ./ITG_x86_SS7_DSS1_QSIG_CAS2_SIP.IB_SIP.T.r64
          '';

          cp-logs = pkgs.writeShellScriptBin "cp-logs" ''
            [ -z "$1" ] && DST="artifacts/bin" || DST="$1"

            CID=$(docker run -d -v itg-build:/itg-build itg-builder true)

            rm -rf "$DST/logs"
            docker cp $CID:/itg-build/build/usr/bin/logs/ "$DST"
            docker rm $CID
          '';

          cp-artifacts = pkgs.writeShellScriptBin "cp-artifacts" ''
            [ -z "$1" ] && DST="artifacts" || DST="$1"

            CID=$(docker run -d -v itg-build:/itg-build itg-builder true)

            docker cp $CID:/itg-build/build/usr/bin/ "$DST"
            docker rm $CID
          '';

          scripts = [
            build-local
            update-compile-commands
            build
            run
            attach
            cp-artifacts
            cp-logs
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
            openssl
            curl
            libpcap
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
