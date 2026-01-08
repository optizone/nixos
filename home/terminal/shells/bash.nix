_: {
  programs.bash = {
    enable = true;

    initExtra = ''
      macchina -t theme -o host -o kernel -o distribution -o packages -o processor -o memory
    '';
  };
}
