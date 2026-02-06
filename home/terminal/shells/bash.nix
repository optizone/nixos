_: {
  programs.bash = {
    enable = true;

    initExtra = ''
      macchina -t theme -o host -o kernel -o distribution -o packages -o processor -o memory
    '';

    shellAliases = {
      "cd" = "z";
      "cd.." = "cd ..";
      "cd,," = "cd ..";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";

      ",," = "..";
      ",,," = "...";
      ",,,," = "....";
      ",,,,," = ".....";

      "ct" = "clean-trash-bin";
      "ns" = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p";
      "nd" = "NIXPKGS_ALLOW_UNFREE=1 nix develop";
      "ndl" =
        "git reset -- flake.nix flake.lock && git add --intent-to-add flake.nix flake.lock && nd && git update-index --assume-unchanged flake.nix flake.lock";
      "ndhide" =
        "git add --intent-to-add flake.nix flake.lock &&
        git update-index --assume-unchanged flake.nix flake.lock";
      "nv" = "nvim .";
    };

  };
}
