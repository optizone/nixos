_: {
  imports = [
    ./terminal/apps/macchina
    ./terminal/apps/starship.nix
    ./terminal/shells/bash.nix
  ];

  programs.git.enable = true;
}
