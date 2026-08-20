{
  username,
  pkgs,
  ...
}: let
  zmount = pkgs.writeShellScriptBin "zmount" ''
    udisksctl mount -b /dev/disk/by-id/usb-KINGSTON_SKC600512G_012345678999-0:0
    udisksctl mount -b /dev/disk/by-id/ata-KINGSTON_SKC600512G_50026B7785B7D037
    udisksctl mount -b /dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55EA573F5E38169B20100-0:0
  '';

  zunmount = pkgs.writeShellScriptBin "zunmount" ''
    udisksctl unmount -b /dev/disk/by-id/usb-KINGSTON_SKC600512G_012345678999-0:0
    udisksctl unmount -b /dev/disk/by-id/ata-KINGSTON_SKC600512G_50026B7785B7D037
    udisksctl unmount -b /dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55EA573F5E38169B20100-0:0
  '';
in {
  environment.systemPackages = [zmount zunmount pkgs.udisks];

  services.udisks2.enable = true;

  systemd.tmpfiles.rules = [
    "d /var/run/media/${username} 0755 ${username} users"
    "L /home/${username}/zroot/shuttles/k1 - - - - /run/media/${username}/9b67994f-39ae-49c5-956b-c9ecdb685f9e"
    "L /home/${username}/zroot/shuttles/k2 - - - - /run/media/${username}/5ccc0817-2cf4-423e-8782-5e89e6e06569"
    "L /home/${username}/zroot/shuttles/k3 - - - - /run/media/${username}/de9ad2fa-01f4-48fc-9a27-bfa57e459cfa"
  ];
}
