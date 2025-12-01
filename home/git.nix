{
  username,
  gitUsername,
  gitEmail,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "${gitUsername}";
        email = "${gitEmail}";
      };

      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = true;
      url = {
        "git@github.com:".insteadOf = [
          "gh:"
          "https://github.com/"
        ];
      };
      core.excludesFile = "/home/${username}/.config/git/.gitignore";
    };

  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      line-numbers = true;
      side-by-side = false;
      diff-so-fancy = true;
      navigate = true;
    };
  };

  xdg.configFile."git/.gitignore".text = ''
    .vscode
  '';
}
