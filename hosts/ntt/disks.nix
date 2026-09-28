{host, ...}: {
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

  fileSystems."/zroot".neededForBoot = true;

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
      hdd = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST4000DM004-2U9104_ZFN5NX7G";

        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f" "-U" "695e90ea-dc4b-4eef-9fe2-6b3fc7e98e6c"];

                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  "/zroot" = {
                    mountpoint = "/zroot";
                    mountOptions = [
                      "subvol=zroot"
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  "/zroot/ldata/backups" = {
                    mountpoint = "/zroot/ldata/backups";
                    mountOptions = [
                      "subvol=backups"
                      "compress=zlib:9"
                      "noatime"
                    ];
                  };

                  "/zroot/ldata/disk-images" = {
                    mountpoint = "/zroot/ldata/disk-images";
                    mountOptions = [
                      "subvol=disk-images"
                      "compress=zlib:9"
                      "noatime"
                    ];
                  };

                  "/zroot/ldata/media" = {
                    mountpoint = "/zroot/ldata/media";
                    mountOptions = [
                      "subvol=media"
                      "compress=none"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
