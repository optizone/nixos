{
  username,
  host,
  ...
}: {
  users.users.${username}.extraGroups = ["incus-admin"];

  virtualisation = {
    incus = {
      enable = true;
      socketActivation = true;
    };

    podman = {
      enable = true;
    };
  };

  networking.nftables.enable = true;
  networking.firewall.trustedInterfaces = ["incusbr0"];

  # TODO: check for relevance
  environment.persistence."/zroot/ldata/persist/${host}" = {
    directories = [
      "/var/lib/docker" # NOTE: from podman
      "/var/lib/incus"
      "/var/lib/libvirt"
      "/var/lib/lxc"
      "/var/lib/lxcfs"
      "/var/lib/qemu"
    ];
  };
}
