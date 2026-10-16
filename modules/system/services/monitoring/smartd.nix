{
  username,
  pkgs,
  host,
  ...
}: {
  # NOTE: add `services.smartd.devices = [{device=...;}];` to host configuration to match your hardware

  # TODO: move
  home-manager.users.${username}.home.packages = with pkgs; [
    sysbench
    stress-ng
    smartmontools
    wakatime-cli
    iperf
    htop
  ];

  # TODO: move htop
  environment.persistence."/zroot/ldata/persist/${host}" = {
    users.${username}.files = [
      ".config/htop/htoprc"
    ];
  };

  services = {
    smartd = {
      enable = true;
    };
  };
}
