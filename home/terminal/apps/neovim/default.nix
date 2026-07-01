{inputs, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    inputs.nvf.homeManagerModules.default
    ../yazi
    ../fzf.nix
    ../lazygit.nix
  ];

  programs.nvf = {
    enable = true;
    settings = import ./config.nix;
  };
}
