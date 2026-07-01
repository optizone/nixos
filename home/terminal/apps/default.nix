{pkgs, ...}: {
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
    wiremix
  ];

  imports = [
    ./eza
    ./fd.nix
    ./dust.nix
    ./fastfetch
    ./macchina
    ./yazi
    ./rmpc
    ./neovim
    ./bat.nix
    ./btop.nix
    ./fzf.nix
    ./lazygit.nix
    ./starship.nix
    ./wiki/wikiman.nix
    ./wiki/tldr.nix
    ./zoxide.nix
  ];
}
