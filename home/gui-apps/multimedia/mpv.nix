{pkgs, ...}: {
  home.packages = with pkgs; [mpv];

  xdg.configFile."mpv/mpv.conf".text = ''
    audio-file-auto=fuzzy
    hwdec=auto
  '';
}
