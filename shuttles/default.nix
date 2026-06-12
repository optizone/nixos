{ username, pkgs, ... }:
let
  zmount-script = pkgs.writeShellScript "zmount" ''
    udisksctl mount -b /dev/disk/by-id/usb-KINGSTON_SKC600512G_012345678999-0:0
    udisksctl mount -b /dev/disk/by-id/ata-KINGSTON_SKC600512G_50026B7785B7D037
  '';

  zmount = pkgs.writeScriptBin "zmount" zmount-script;
in
{
  environment.systemPackages = [ zmount ];

  systemd.tmpfiles.rules = [
    "d /var/run/media/${username} 0755 ${username} users"
    # FIXME: hack around priveleges
    "d /var/run/media/${username}/2ad2142a-8f34-4deb-ad59-96319d1f3326 0755 ${username} users"
    "d /var/run/media/${username}/cbce37c2-e57a-432c-9f0c-a85618d35ca7 0755 ${username} users"
    "L /home/${username}/zroot/shuttles/k1 - - - - /run/media/${username}/2ad2142a-8f34-4deb-ad59-96319d1f3326"
    "L /home/${username}/zroot/shuttles/k2 - - - - /run/media/${username}/cbce37c2-e57a-432c-9f0c-a85618d35ca7"
  ];
}
