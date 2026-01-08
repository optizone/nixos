{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    ripgrep
    killall
    man-pages
    nixfmt-rfc-style
    pamixer
    poweralertd
    shfmt
    unzip
    wget
    file
    netcat
  ];

  imports = [
    ./eza
    ./fd.nix
    ./dust.nix
    ./fastfetch
    ./macchina
    ./yazi
    ./neovim
    ./bat.nix
    ./btop.nix
    ./fzf.nix
    ./lazygit.nix
    ./starship.nix
    ./zoxide.nix
  ];

}
