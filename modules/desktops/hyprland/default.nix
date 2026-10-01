{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    ../utils
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
