_: {
  disko.devices.disk = {
    k2 = {
      type = "disk";
      device = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55EA573F5E38169B20100-0:0";

      content = {
        type = "btrfs";
        extraArgs = ["-f"];
        subvolumes = {
          "/zroot" = {
            mountpoint = "/zroot";
            mountOptions = [ "compress=lz4" ];
          };

          "/nix" = {
            mountpoint = "/nix";
            mountOptions = [ "compress=lz4" ];
          };
        };
      };
    };
  };
}
