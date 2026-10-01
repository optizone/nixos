_: {
  services.nfs.server = {
    enable = true;

    # TODO: uid guid
    exports = ''
      /znode/share              192.168.88.0/22(rw,fsid=0,no_subtree_check)
      /znode/share/backups      192.168.88.0/22(rw,nohide,insecure,no_subtree_check)
      /znode/share/disk-images  192.168.88.0/22(rw,nohide,insecure,no_subtree_check)
      /znode/share/media        192.168.88.0/22(rw,nohide,insecure,no_subtree_check)
      /znode/share/kiwix-images 192.168.88.0/22(rw,nohide,insecure,no_subtree_check)
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
