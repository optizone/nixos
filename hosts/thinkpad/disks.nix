{
  username,
  host,
  ...
}: {
  environment.persistence."/zroot/ldata/persist/${host}" = {
    enable = true;
    hideMounts = true;

    directories = [
      "/etc/ssh"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
      "/var/lib/systemd/timers"
    ];

    files = [
      # TODO: check if works. some say gnerates at boot anyway
      "/etc/machine-id"
    ];

    users.${username}.files = [
      ".config/htop/htoprc"
    ];
  };

  sops.age.sshKeyPaths = [
    "/zroot/ldata/persist/etc/ssh/ssh_host_ed25519_key"
  ];

  services.smartd = {
    enable = true;
    devices = [
      {device = "/dev/nvme0";}
    ];
  };

  fileSystems."/zroot".neededForBoot = true;

  disko.devices.disk = {
    nvme = {
      type = "disk";
      device = "/dev/nvme0";

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
              extraArgs = ["-f" "-U" "e990756d-cb1b-450d-8ad0-92f063eec49d"];

              subvolumes = {
                "/rootfs" = {
                  mountpoint = "/";
                  mountOptions = [
                    "subvol=root"
                    "compress=zstd"
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

                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "subvol=home"
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zlib:7"
                    "noatime"
                  ];
                };

                "/swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "32GB";
                };
              };
            };
          };
        };
      };
    };
  };
}
