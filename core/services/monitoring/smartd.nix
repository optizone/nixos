{
  username,
  pkgs,
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

  services = {
    smartd = {
      enable = true;
    };
  };
}
