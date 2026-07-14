{pkgs, ...}: let
  zcontact = pkgs.writeShellScriptBin "zcontact" ''
    OPTIONS=$'gn01\ngn02\nst01\nst02'
    [ -z "$1" ] && \
      DEV=$(echo "$OPTIONS" | rofi -dmenu -theme-str 'window {width: 10%;} listview {columns: 1;}') || \
      DEV="$1"

    case "$DEV" in
      gn01) BT="8C:FD:49:B5:D8:15" ;;
      gn02) BT="E8:F6:0A:CB:1A:09" ;;
      st01) BT="ED:96:E1:99:09:20" ;;
      st02) BT="C7:80:90:01:30:2E" ;;
      *) exit 1
    esac

    contact --ble $BT
  '';
in {
  home.packages = [
    pkgs.contact
    zcontact
  ];
}
