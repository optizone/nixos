_: {
  disko.devices.disk = {
    k1 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-KINGSTON_SKC600512G_50026B7785B7D037";

      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        subvolumes = {
          "/zroot" = {
            mountOptions = [ "compress=lz4" ];
          };

          "/nix" = {
            mountOptions = [ "compress=lz4" ];
          };

          "/ldata" = {
            mountOptions = [ "compress=lz4" ];
          };
        };
      };
    };
  };
}
