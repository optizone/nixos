{username, ...}: {
  environment.persistence."/znode/persist" = {
    enable = true;
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/lib/containers"

      {
        directory = "/var/lib/grocy";
        user = "grocy";
        group = "nginx";
      }
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
      }
      {
        directory = "/var/lib/zigbee2mqtt";
        user = "zigbee2mqtt";
        group = "zigbee2mqtt";
      }
      {
        directory = "/var/lib/mosquitto";
        user = "mosquitto";
        group = "mosquitto";
      }
      {
        # matter-server AdGuardHome
        directory = "/var/lib/private/";
        mode = "0700";
      }
      {
        directory = "/var/lib/private/matter-server";
        user = "nobody";
        group = "nogroup";
      }
      {
        directory = "/var/lib/private/AdGuardHome";
        user = "nobody";
        group = "nogroup";
      }
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];

    users.${username}.files = [
      ".config/htop/htoprc"
    ];
  };

  sops.age.sshKeyPaths = [
    "/znode/persist/etc/ssh/ssh_host_ed25519_key"
  ];

  services.smartd = {
    enable = true;
    devices = [
      {device = "/dev/disk/by-id/ata-WDC_WD10JPCX-24UE4T0_WD-WX31A9611N2C";}
      {device = "/dev/disk/by-id/ata-WDC_WD10SPZX-21Z10T0_WD-WX42A2139YKS";}
    ];
  };

  fileSystems."/znode/persist".neededForBoot = true;

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=6G"
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
              priority = 1;

              size = "1024M";
              label = "FIRMWARE";
              type = "0700";
              attributes = [
                0 # Required Partition
              ];

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
              type = "EF00";
              attributes = [
                2 # Legacy BIOS Bootable, for U-Boot to find extlinux config
              ];

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
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };

      a = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD10JPCX-24UE4T0_WD-WX31A9611N2C";

        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      b = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD10SPZX-21Z10T0_WD-WX42A2139YKS";

        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
    };

    zpool = {
      tank = {
        type = "zpool";
        mode = "mirror";

        datasets = {
          persist = {
            type = "zfs_fs";
            mountpoint = "/znode/persist";
            options.compression = "lz4";
          };

          backups = {
            type = "zfs_fs";
            mountpoint = "/znode/share/backups";
            options.compression = "lz4";
          };

          disk-images = {
            type = "zfs_fs";
            mountpoint = "/znode/share/disk-images";
            options = {
              compression = "lz4";
              recordsize = "4M";
            };
          };

          wiki = {
            type = "zfs_fs";
            mountpoint = "/znode/share/wiki";
            options.recordsize = "1M";
          };

          media = {
            type = "zfs_fs";
            mountpoint = "/znode/share/media";
            options.recordsize = "4M";
          };

          home = {
            type = "zfs_fs";
            mountpoint = "/znode/share/home";
            options.compression = "lz4";
          };
        };
      };
    };
  };
}
