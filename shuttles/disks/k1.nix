_: {
  disko.devices.disk = {
    k1 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-KINGSTON_SKC600512G_50026B7785B7D037";

      content = {
        type = "btrfs";
        extraArgs = ["-f" "-U" "9b67994f-39ae-49c5-956b-c9ecdb685f9e"];
        subvolumes = {
          "/zroot" = {
            mountpoint = "/zroot";
            mountOptions = ["compress=zlib"];
          };

          "/nix" = {
            mountpoint = "/nix";
            mountOptions = ["compress=zlib"];
          };
        };
      };
    };
  };
}
