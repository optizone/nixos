{
  pkgs,
  stateVersion,
  username,
  ...
}: {
  # ==============================

  nix = {
    settings = {
      auto-optimise-store = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    optimise = {
      automatic = true;
      dates = ["03:45"];
    };

    channel.enable = false;
  };

  system.stateVersion = "${stateVersion}";

  # ==============================

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  # ==============================

  security = {
    rtkit.enable = true;

    sudo = {
      enable = true;
      extraConfig = ''
        Defaults lecture = never
      '';
    };
  };

  # ==============================

  # TODO: move to ssh?
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavor = "";
    };
    nix-ld.enable = true;
  };

  # ==============================

  # TODO: enable after moving thinkpad to disko
  # systemd.tmpfiles.rules = [
  #   "d /zroot 0750 ${username} users"
  #
  #   "d /zroot/ldata 0750 ${username} users"
  #   "d /zroot/ldata/backups 0750 ${username} users"
  #   "d /zroot/ldata/builds 0750 ${username} users"
  #   "d /zroot/ldata/code 0750 ${username} users"
  #   "d /zroot/ldata/disk-images 0750 ${username} users"
  #   "d /zroot/ldata/media 0750 ${username} users"
  #   "d /zroot/ldata/secrets 0750 ${username} users"
  #   "d /zroot/ldata/wiki 0750 ${username} users"
  #   "d /zroot/ldata/persist 0750 ${username} users"
  #
  #   "d /zroot/nas 0750 ${username} users"
  #   "d /zroot/shuttles 0750 ${username} users"
  #   "d /zroot/notes 0750 ${username} users"
  #
  #   "L /home/${username}/zroot - - - - /zroot"
  #
  #   # FIXME: shuttles
  # ];
}
