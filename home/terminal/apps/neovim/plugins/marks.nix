{ pkgs, ... }:
{
  config.vim.lazy.plugins = {
    "marks.nvim" = {
      package = pkgs.vimPlugins.marks-nvim;

      setupModule = "marks";
      setupOpts = { };
    };
  };
}
