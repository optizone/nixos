{ pkgs, inputs, ... }:
let
  customNeovim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ ./neovim ];
  };
in
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
    customNeovim.neovim
  ];

  imports = [
    ./eza/default.nix
    ./fd.nix
    ./dust.nix
    ./fastfetch/default.nix
    ./yazi/default.nix
    ./bat.nix
    ./btop.nix
    ./fzf.nix
    ./lazygit.nix
    ./starship.nix
    ./zoxide.nix
  ];

}
