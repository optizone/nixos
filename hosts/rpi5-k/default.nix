{
  pkgs,
  config,
  nixos-raspberrypi,
  username,
  host,
  hostId,
  ...
}:
{
  # TODO: this is a mess, please, clean it up asap

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://nixos-raspberrypi.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };
    channel.enable = false;
  };

  environment.systemPackages = with pkgs; [
    pciutils
    git
    vim
  ];

  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.bluetooth

    ./disko.nix
    ./hardware-configuration.nix
    ../../core/system/sops.nix

    ../../core/system/nh.nix

    ./nginx.nix
    ../../core/services/smb.nix
    ../../core/services/nfs.nix
    ../../core/services/jellyfin.nix
    ../../core/services/grocy.nix

    ../../home/flavours/headless-module.nix
    ../../home/terminal/apps/starship.nix
  ];

  networking.hostName = "${host}";
  networking.hostId = "${hostId}";

  system.nixos.tags =
    let
      cfg = config.boot.loader.raspberryPi;
    in
    [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];

  programs.git.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];

    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "${username}" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  boot.loader.raspberryPi.bootloader = "kernel";

  sops.secrets."${host}/user-pass-hash".neededForUsers = true;
  sops.secrets."${host}/root-pass-hash".neededForUsers = true;

  users.users.root = {
    hashedPasswordFile = config.sops.secrets."${host}/root-pass-hash".path;
    openssh.authorizedKeys.keys = [
      # YOUR SSH PUB KEY HERE #
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSc1iIJ63VM55CIWnu4U8/YoqkKXr8QK+N74UcltYvY"
    ];
  };

  users.users.${username} = {
    home = "/home/${username}";
    hashedPasswordFile = config.sops.secrets."${host}/user-pass-hash".path;

    openssh.authorizedKeys.keys = [
      # YOUR SSH PUB KEY HERE #
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSc1iIJ63VM55CIWnu4U8/YoqkKXr8QK+N74UcltYvY"
    ];

    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "users"
      "wheel"
    ];
  };

  hardware.raspberry-pi.extra-config = ''
    dtparam=pciex1
    dtparam=pciex1_gen=3
  '';

  nix.settings.allowed-users = [ "${username}" ];
}
