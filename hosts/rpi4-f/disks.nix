_: {
  environment.persistence."/znode/persist" = {
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
    "/znode/persist/etc/ssh/ssh_host_ed25519_key"
  ];

  fileSystems."/znode/persist".neededForBoot = true;

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
              size = "8G";

              content = {
                type = "filesystem";
                mountpoint = "/nix";
                format = "ext4";
                mountOptions = ["noatime"];
              };
            };

            persist = {
              label = "PERSIST";
              size = "2G";

              content = {
                type = "filesystem";
                mountpoint = "/znode/persist";
                format = "ext4";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
    };
  };
}
