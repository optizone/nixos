{ pkgs, ... }:
{
  config.vim = {
    languages.markdown = {
      enable = true;

      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;

      extensions.render-markdown-nvim = {
        enable = true;
        setupOpts = {
          html.comment.conceal = false;
          checkbox.enabled = false;
          bullet.enabled = false;
        };
      };
    };

    utility = {
      preview.markdownPreview.enable = true;
    };

    lazy.plugins = {
      "bullets.vim" = {
        package = pkgs.vimPlugins.bullets-vim;
      };
    };
  };
}
