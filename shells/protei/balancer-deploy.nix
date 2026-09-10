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
          BUILD_DIR = "../../../builds/balancer-deploy";
          BUILD_FILE = "./build_almaz.yaml";

          # ========== SCRIPTS ==========

          setup-vm = pkgs.writeShellScriptBin "setup-vm" ''
            vm_name="''${1:-l37-test-env}";

            incus launch images:debian/13 "$vm_name" --vm -c limits.cpu=4

            echo "Waiting for VM to launch..."
            sleep 30

            # ==== Docker install ====
            incus exec "$vm_name" -- apt update
            incus exec "$vm_name" -- install -m 0755 -d /etc/apt/keyrings
            incus exec "$vm_name" -- curl -fsSL https://download.docker.com/linux/debian/gpg -o \
                /etc/apt/keyrings/docker.asc
            incus exec "$vm_name" -- chmod a+r /etc/apt/keyrings/docker.asc
            incus exec "$vm_name" -- sh -c 'tee /etc/apt/sources.list.d/docker.sources <<EOF
            Types: deb
            URIs: https://download.docker.com/linux/debian
            Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
            Components: stable
            Architectures: $(dpkg --print-architecture)
            Signed-By: /etc/apt/keyrings/docker.asc
            EOF'
            incus exec "$vm_name" -- apt update
            incus exec "$vm_name" -- apt install --yes docker-ce docker-ce-cli containerd.io \
                docker-buildx-plugin docker-compose-plugin

            # ==== Other deps ====
            incus exec "$vm_name" -- apt install --yes snapd pipx make git iptables
            incus exec "$vm_name" -- pipx install uv
            incus exec "$vm_name" -- pipx ensurepath
            incus exec "$vm_name" -- snap install lxd

            echo ""
            echo "======================"
            echo "Run 'lxd init && exit'"
            echo "======================"
            incus exec "$vm_name" bash

            incus config device add "$vm_name" \
                balancer-deploy disk \
                source=/home/thinkpad/code/protei/balancer-deploy \
                path=/balancer-deploy
            sleep 2

            echo ""
            echo "======================"
            echo "Run 'make sync && exit'"
            echo "======================"
            incus exec "$vm_name" --cwd /balancer-deploy -- bash
          '';

          access-vm = pkgs.writeShellScriptBin "access-vm" ''
            vm_name="''${1:-l37-test-env}";
            incus exec "$vm_name" --cwd /balancer-deploy -- bash
          '';

          delete-vm = pkgs.writeShellScriptBin "delete-vm" ''
            vm_name="''${1:-l37-test-env}";
            incus delete "$vm_name" --force
          '';

          start-vm = pkgs.writeShellScriptBin "start-vm" ''
            vm_name="''${1:-l37-test-env}";
            incus start "$vm_name"
          '';

          stop-vm = pkgs.writeShellScriptBin "stop-vm" ''
            vm_name="''${1:-l37-test-env}";
            incus stop "$vm_name"
          '';

          scripts = [
            setup-vm
            access-vm
            delete-vm
            start-vm
            stop-vm
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

            python314
            uv
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
