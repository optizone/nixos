{ pkgs, ... }:
let
  wikiman-update-sources-sh = pkgs.writeShellScript "wikiman-update-source" ''
    ${pkgs.curl}/bin/curl -L 'https://raw.githubusercontent.com/filiparag/wikiman/master/Makefile' -o 'wikiman-makefile'

    ${pkgs.gnumake}/bin/make -f ./wikiman-makefile source-arch
    sudo ${pkgs.gnumake}/bin/make -f ./wikiman-makefile source-install
    sudo ${pkgs.gnumake}/bin/make -f ./wikiman-makefile clean

    rm wikiman-makefile
    rm srcbuild
  '';

  wikiman-update-sources = pkgs.writeScriptBin "wikiman-update-source" wikiman-update-sources-sh;
in
{
  home.packages = with pkgs; [
    (wikiman.overrideAttrs (
      _: previousAttrs: {
        patches = previousAttrs.patches ++ [ ./doc-path-patch.patch ];
      }
    ))

    wikiman-update-sources
  ];

  xdg.configFile."wikiman/wikiman.conf".text = ''
    # Sources (if empty, use all available)
    sources = arch

    # Fuzzy finder
    fuzzy_finder = fzf

    # Quick search mode (only by title)
    quick_search = true

    # Raw output (for developers)
    raw_output = false

    # Manpages language(s)
    man_lang = en

    # Output postprocessing
    postprocess_man = bat -l man --color always --style plain

    # Wiki language(s)
    # wiki_lang = zh-CN

    # Show previews in TUI
    tui_preview = true

    # Keep open after viewing a result
    tui_keep_open = true

    # Show source column
    tui_source_column = true

    # Viewer for HTML pages
    tui_html = qutebrowser
  '';
}
