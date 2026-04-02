{ ... }:
{
  imports = [
    ./hardware.nix
    ./xserver.nix
    ./hyprland.nix
    ./niri.nix
    ./program.nix
  ];

  services.displayManager.ly.enable = true;
}
