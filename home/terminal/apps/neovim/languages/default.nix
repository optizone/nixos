{ ... }:
{
  imports = [
    ./markdown.nix
    ./typst.nix
  ];

  programs.nvf.settings.config.vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    nix = {
      enable = true;
      format = {
        enable = true;
        type = "nixfmt";
      };
      lsp = {
        enable = true;
        # server = "nixd";
      };
      treesitter.enable = true;
    };

    bash.enable = true;
    clang = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    css.enable = true;
    html.enable = true;
    sql.enable = true;
    java.enable = true;
    kotlin.enable = true;
    ts.enable = true;
    go.enable = true;
    lua.enable = true;
    zig.enable = true;
    python.enable = true;
    rust = {
      enable = true;
      crates.enable = true;
      lsp.opts = ''
        ['rust-analyzer'] = {
          cargo = { allFeature = true },
          checkOnSave = true,
          procMacro = {
            enable = true,
          },
          diagnostics = {
            enable = true,
          },
        },
      '';
    };
    typst.enable = true;
  };
}
