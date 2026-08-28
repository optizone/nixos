_: {
  disko.devices.disk = {
    k2 = {
      type = "disk";
      device = "/dev/disk/by-id/usb-General_UDisk-0:0";

      content = {
        type = "btrfs";
        extraArgs = ["-f" "-U" "de9ad2fa-01f4-48fc-9a27-bfa57e459cfa"];
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
