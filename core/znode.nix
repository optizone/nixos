{pkgs, ...}: {
  imports = [
    ./system/network/znode.nix
    ./system/settings.nix
    ./system/sops.nix

    ./programs/nh.nix

    ./virtualization/host.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    htop
    iotop
    iperf
    lsof
  ];

  nix.settings = {
    build-dir = "/zroot/ldata/builds/nix";
    keep-failed = true;
  };

  users.users.nixremotebuilder = {
    description = "nix remote builder";
    isSystemUser = true;
    createHome = false;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/cBsavT5TcgtRKwvfF64jTUgfIEEBGn75gHv7GuIc6"
    ];

    uid = 500;
    group = "nixremotebuilder";
    useDefaultShell = true;
  };

  users.groups.nixremotebuilder = {
    gid = 500;
  };

  nix.settings.trusted-users = ["nixremotebuilder"];

  services.openssh.settings.AllowUsers = [
    "nixremotebuilder"
  ];
}
