{
  inputs,
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    imports = [
      ./keymap.nix
      ./yazi.nix
    ];

    home.packages = with pkgs; [
      dragon-drop
      file
    ];

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";

      theme = {
        flavor.dark = "gruvbox-dark";
      };

      plugins = {
        git = "${inputs.yazi-plugins}/git.yazi";
        mount = "${inputs.yazi-plugins}/mount.yazi";
        smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
        full-border = "${inputs.yazi-plugins}/full-border.yazi";
        chmod = "${inputs.yazi-plugins}/chmod.yazi";
      };

      flavors = {
        gruvbox-dark = ./gruvbox-dark.yazi;
      };
    };

    xdg.configFile."yazi/init.lua".text = ''
      require("git"):setup()
      require("full-border"):setup()
    '';
  };
}
