_: {
  disko.devices.disk = {
    k2 = {
      type = "disk";
      device = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55EA573F5E38169B20100-0:0";

      content = {
        type = "btrfs";
        extraArgs = ["-f" "-U" "5ccc0817-2cf4-423e-8782-5e89e6e06569"];
        subvolumes = {
          "/zroot" = {
            mountpoint = "/zroot";
            mountOptions = ["compress=zlib"];
          };
        };
      };
    };
  };
}
