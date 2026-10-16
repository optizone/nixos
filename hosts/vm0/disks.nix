{
  host,
  pkgs,
  ...
}: {
  environment.persistence."/zroot/ldata/persist/${host}" = {
    enable = true;
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  sops.age.sshKeyPaths = [
    "/zroot/ldata/persist/${host}/etc/ssh/ssh_host_ed25519_key"
  ];

  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "256M";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                    };
                    "/zroot" = {
                      mountpoint = "/zroot";
                      mountOptions = ["subvol=zroot" "compress=zstd" "noatime"];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["subvol=log" "compress=zstd" "noatime"];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      mountOptions = ["subvol=swap" "noatime" "nodatacow" "compress=no"];
                      swap.swapfile.size = "8G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/zroot".neededForBoot = true;
    "/swap".neededForBoot = true;
    "/var/log".neededForBoot = true;
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-partlabel/luks";
      allowDiscards = true;
      preLVM = true;
    };
  };

  boot.initrd.systemd = {
    services.impermance-btrfs-rolling-root = {
      description = "Archiving existing BTRFS root subvolume and creating a fresh one";
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
      };
      requiredBy = ["initrd.target"];
      before = ["sysroot.mount"];

      requires = ["initrd-root-device.target"];
      after = [
        "initrd-root-device.target"
        "local-fs-pre.target"
      ];

      script = ''
        mkdir /btrfs_tmp
        mount -t btrfs /dev/mapper/cryptroot /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };
    extraBin = {
      # "mkfs.ext4" = "${pkgs.e2fsprogs}/bin/mkfs.ext4";
      "mkdir" = "${pkgs.coreutils}/bin/mkdir";
      "date" = "${pkgs.coreutils}/bin/date";
      "stat" = "${pkgs.coreutils}/bin/stat";
      "mv" = "${pkgs.coreutils}/bin/mv";
      "find" = "${pkgs.findutils}/bin/find";
      "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
      # mount & umount already exist
    };
  };

  # disko.devices = {
  #   disk = {
  #     hdd = {
  #       type = "disk";
  #       device = "/dev/sda";
  #
  #       content = {
  #         type = "gpt";
  #         partitions = {
  #           ESP = {
  #             priority = 1;
  #             name = "ESP";
  #             start = "1M";
  #             end = "128M";
  #             type = "EF00";
  #
  #             content = {
  #               type = "filesystem";
  #               format = "vfat";
  #               mountpoint = "/boot";
  #               mountOptions = ["umask=0077"];
  #             };
  #           };
  #
  #           root = {
  #             size = "100%";
  #             content = {
  #               type = "btrfs";
  #               extraArgs = ["-f" "-U" "695e90ea-dc4b-4eef-9fe2-6b3fc7e98e6c"];
  #
  #               subvolumes = {
  #                 "/" = {
  #                   mountpoint = "/";
  #                   mountOptions = [
  #                     "subvol=root"
  #                     "compress=zstd"
  #                   ];
  #                 };
  #
  #                 "/nix" = {
  #                   mountpoint = "/nix";
  #                   mountOptions = [
  #                     "subvol=nix"
  #                     "compress=zstd"
  #                     "noatime"
  #                   ];
  #                 };
  #
  #                 "/home" = {
  #                   mountpoint = "/home";
  #                   mountOptions = [
  #                     "subvol=home"
  #                     "compress=zstd"
  #                     "noatime"
  #                   ];
  #                 };
  #
  #                 "/zroot" = {
  #                   mountpoint = "/zroot";
  #                   mountOptions = [
  #                     "subvol=zroot"
  #                     "compress=zstd"
  #                     "noatime"
  #                   ];
  #                 };
  #
  #                 "/zroot/ldata/backups" = {
  #                   mountpoint = "/zroot/ldata/backups";
  #                   mountOptions = [
  #                     "subvol=backups"
  #                     "compress=zlib:9"
  #                     "noatime"
  #                   ];
  #                 };
  #
  #                 "/zroot/ldata/disk-images" = {
  #                   mountpoint = "/zroot/ldata/disk-images";
  #                   mountOptions = [
  #                     "subvol=disk-images"
  #                     "compress=zlib:9"
  #                     "noatime"
  #                   ];
  #                 };
  #
  #                 "/zroot/ldata/media" = {
  #                   mountpoint = "/zroot/ldata/media";
  #                   mountOptions = [
  #                     "subvol=media"
  #                     "compress=none"
  #                     "noatime"
  #                   ];
  #                 };
  #               };
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
