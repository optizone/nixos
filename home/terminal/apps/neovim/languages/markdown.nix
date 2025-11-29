{ pkgs, ... }:
{
  programs.nvf.settings.config.vim = {
    languages.markdown = {
      enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
      extensions.render-markdown-nvim.enable = true;
    };

    utility = {
      preview.markdownPreview.enable = true;
      images.img-clip.enable = true;
      images.image-nvim = {
        enable = false;
        setupOpts = {
          backend = "kitty";
          integrations.markdown.enable = true;
        };
      };
    };

    lazy.plugins = {
      "bullets.vim" = {
        package = pkgs.vimPlugins.bullets-vim;
      };

      # TODO: enable markdown-toc

      # "markdown-toc.nvim" = {
      #   package = pkgs.vimPlugins.markdown-toc;
      # };
    };
  };
}
