_: {
  services.nfs.server = {
    enable = true;

    # TODO: uid guid
    exports = ''
      /export              192.168.68.0/22(rw,fsid=0,no_subtree_check)
      /export/backups      192.168.68.0/22(rw,nohide,insecure,no_subtree_check)
      /export/disk-images  192.168.68.0/22(rw,nohide,insecure,no_subtree_check)
      /export/media        192.168.68.0/22(rw,nohide,insecure,no_subtree_check)
      /export/kiwix-images 192.168.68.0/22(rw,nohide,insecure,no_subtree_check)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
    ];

    allowedUDPPorts = [
      111
      2049
    ];
  };
}
