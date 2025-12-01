_: {
  programs.nvf.settings.config.vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
      transparent = true;
    };

    # TODO: fix upstream or local
    highlight = {
      NeoTreeGitModified = {
        fg = "#fabd2f";
      };

      NetreeGitAdded = {
        fg = "#fabd2f";
      };
    };

    # -- NeoTreeDirectoryName = { link = "Directory" },
    # -- NeoTreeDotfile = { fg = colors.fg4 },
    # -- NeoTreeFadeText1 = { fg = colors.fg3 },
    # -- NeoTreeFadeText2 = { fg = colors.fg4 },
    # -- NeoTreeFileIcon = { fg = colors.blue },
    # -- NeoTreeFileName = { fg = colors.fg1 },
    # -- NeoTreeFileNameOpened = { fg = colors.fg1, bold = true },
    # -- NeoTreeFileStats = { fg = colors.fg3 },
    # -- NeoTreeFileStatsHeader = { fg = colors.fg2, italic = true },
    # -- NeoTreeFilterTerm = { link = "SpecialChar" },
    # -- NeoTreeHiddenByName = { link = "NeoTreeDotfile" },
    # -- NeoTreeIndentMarker = { fg = colors.fg4 },
    # -- NeoTreeMessage = { fg = colors.fg3, italic = true },
    # -- NeoTreeModified = { fg = colors.yellow },
    # -- NeoTreeRootName = { fg = colors.fg1, bold = true, italic = true },
    # -- NeoTreeSymbolicLinkTarget = { link = "NeoTreeFileName" },
    # -- NeoTreeExpander = { fg = colors.fg4 },
    # -- NeoTreeWindowsHidden = { link = "NeoTreeDotfile" },
    # -- NeoTreePreview = { link = "Search" },
    # -- NeoTreeGitAdded = { link = "GitGutterAdd" },
    # -- NeoTreeGitConflict = { fg = colors.orange, bold = true, italic = true },
    # -- NeoTreeGitDeleted = { link = "GitGutterDelete" },
    # -- NeoTreeGitIgnored = { link = "NeoTreeDotfile" },
    # -- NeoTreeGitModified = { link = "GitGutterChange" },
    # -- NeoTreeGitRenamed = { link = "NeoTreeGitModified" },
    # -- NeoTreeGitStaged = { link = "NeoTreeGitAdded" },
    # -- NeoTreeGitUntracked = { fg = colors.orange, italic = true },
    # -- NeoTreeGitUnstaged = { link = "NeoTreeGitConflict" },
    # -- NeoTreeTabActive = { fg = colors.fg1, bold = true },
    # -- NeoTreeTabInactive = { fg = colors.fg4, bg = colors.bg1 },
    # -- NeoTreeTabSeparatorActive = { fg = colors.bg1 },
    # -- NeoTreeTabSeparatorInactive = { fg = colors.bg2, bg = colors.bg1 },
  };
}
