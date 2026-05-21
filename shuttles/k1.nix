_: {
  disko.devices = {
    disk = {
      iva = {
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

            "/data" = {
              mountOptions = [ "compress=lz4" ];
            };
          };
        };
      };
    };
  };
}

# _: {
#   disko.devices = {
#     disk = {
#       iva = {
#         type = "disk";
#         device = "/dev/disk/by-id/ata-KINGSTON_SKC600512G_50026B7785B7D037";
#
#         content = {
#           type = "gpt";
#           partitions = {
#             luks = {
#               size = "100%";
#               content = {
#                 type = "luks";
#                 name = "crypted";
#
#                 settings = {
#                   allowDiscards = true;
#                   # keyFile = "/tmp/secret.key";
#                 };
#
#                 # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
#
#                 content = {
#                   type = "btrfs";
#                   extraArgs = [ "-f" ];
#                   subvolumes = {
#                     "/zroot" = {
#                       mountOptions = [ "compress=lz4" ];
#                     };
#
#                     "/nix" = {
#                       mountOptions = [ "compress=lz4" ];
#                     };
#
#                     "/data" = {
#                       mountOptions = [ "compress=lz4" ];
#                     };
#                   };
#                 };
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }
