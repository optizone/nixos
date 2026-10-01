{
  inputs,
  username,
  ...
}: {
  imports = [
    ../../file-managers/yazi
    ../../utils/fzf.nix
    ../../utils/lazygit.nix
  ];

  home-manager.users.${username} = {
    imports = [
      inputs.nvf.homeManagerModules.default
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.nvf = {
      enable = true;
      settings = import ./config.nix;
    };
  };
}
