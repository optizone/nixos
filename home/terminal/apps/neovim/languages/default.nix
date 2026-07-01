{...}: {
  imports = [
    ./markdown.nix
    ./typst.nix
  ];

  config.vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    nix.enable = true;
    bash.enable = true;
    clang.enable = true;
    cmake.enable = true;
    docker.enable = true;
    fish.enable = true;
    json.enable = true;
    just.enable = true;
    make.enable = true;
    nu.enable = true;
    toml.enable = true;
    yaml.enable = true;
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
      # crates.enable = true;
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
