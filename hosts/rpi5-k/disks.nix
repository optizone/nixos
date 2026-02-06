_: {
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/lib/jellyfin"
      "/var/lib/grocy"
      "/var/lib/zigbee2mqtt"
      "/var/lib/mosquitto"
      {
        # matter-server AdGuardHome
        directory = "/var/lib/private/";
        mode = "0700";
      }
      "/var/lib/containers/storage/volumes/home-assistant"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  sops.age.sshKeyPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
  ];

  fileSystems."/persist".neededForBoot = true;

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "defaults"
        "mode=755"
      ];
    };

    disk = {
      sd = {
        type = "disk";
        device = "/dev/mmcblk0";

        content = {
          type = "gpt";

          partitions = {
            firmware = {
              size = "1024M";
              label = "FIRMWARE";
              type = "0700";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/firmware";
                mountOptions = [
                  "noatime"
                  "noauto"
                  "x-systemd.automount"
                  "x-systemd.idle-timeout=1min"
                ];
              };
            };

            boot = {
              size = "512M";
              label = "BOOT";
              type = "0700";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "noatime"
                  "noauto"
                  "x-systemd.automount"
                  "x-systemd.idle-timeout=1min"
                ];
              };
            };

            nix = {
              label = "NIX";
              size = "100%";

              content = {
                type = "filesystem";
                mountpoint = "/nix";
                format = "ext4";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };

      a = {
        type = "disk";
        # device = "/dev/sdc";
        device = "/dev/disk/by-id/ata-WDC_WD10JPCX-24UE4T0_WD-WX31A9611N2C";

        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };

      b = {
        type = "disk";
        # device = "/dev/sdb";
        device = "/dev/disk/by-id/ata-WDC_WD10SPZX-21Z10T0_WD-WX42A2139YKS";

        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions.compression = "lz4";

        datasets = {
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };

          backups = {
            type = "zfs_fs";
            mountpoint = "/export/backups";
          };

          disk-images = {
            type = "zfs_fs";
            mountpoint = "/export/disk-images";
          };

          kiwix-images = {
            type = "zfs_fs";
            mountpoint = "/export/kiwix-images";
          };

          media = {
            type = "zfs_fs";
            mountpoint = "/export/media";
          };

          home = {
            type = "zfs_fs";
            mountpoint = "/export/home";
          };
        };
      };
    };
  };
}
