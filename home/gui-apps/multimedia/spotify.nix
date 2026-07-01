{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    theme = {
      # Name of the theme
      name = "Gruvify";
      # The source of the theme
      src = pkgs.fetchFromGitHub {
        owner = "Skaytacium";
        repo = "Gruvify";
        rev = "8590028db983bed7d3e93b48d46af58291929025";
        hash = "sha256-UCJWMLcxZ5dT7KZtVaDswtN3MFM+zFylibF+bDE2qiE=";
      };

      # Additional theme options all set to defaults
      # the docs of the theme should say which of these
      # if any you have to change
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      sidebarConfig = true;
      homeConfig = true;
      overwriteAssets = false;
      additonalCss = "";
    };
  };
}
