{ ... }:
{
  programs.nvf.settings.config.vim = {
    languages.typst = {
      enable = true;
      # extensions.typst-concealer.enable = true;
      extensions.typst-preview-nvim.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    formatter.conform-nvim.setupOpts.formatters_by_ft = {
      typst = [ "typstyle" ];
      typ = [ "typstyle" ];
    };
  };
}
