{ pkgs, inputs, ... }:
let
  customNeovim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ ./config.nix ];
  };
in
{
  home.packages = [
    customNeovim.neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ../yazi
    ../fzf.nix
    ../lazygit.nix
  ];
}
