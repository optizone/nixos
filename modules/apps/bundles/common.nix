{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      jq
      ripgrep
      killall
      nixfmt-rfc-style
      poweralertd
      shfmt
      unzip
      wget
      netcat
      (timr-tui.override {enableSound = true;})
      otpclient
      iperf
      nix-inspect
      ffmpeg
      nixos-anywhere
      just
      nixos-rebuild-ng
      htop
      disko
      ssh-to-age
      sops
      gh
    ];
  };

  environment.systemPackages = with pkgs; [
    usbutils
  ];

  programs = {
    nix-index-database.comma.enable = true;
  };
}
