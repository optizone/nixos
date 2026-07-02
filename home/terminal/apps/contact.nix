{pkgs, ...}: let
  zcontact = pkgs.writeShellScriptBin "zcontact" ''
    GN01="8C:FD:49:B5:D8:15"
    GN02="TODO"
    ST01="ED:96:E1:99:09:20"
    ST02="C7:80:90:01:30:2E"

    OPTIONS=$'gn01\ngn02\nst01\nst02'
    DEV=$(echo "$OPTIONS" | rofi -dmenu -theme-str 'window {width: 10%;} listview {columns: 1;}')

    case "$DEV" in
      gn01) BT="$GN01" ;;
      gn02) BT="$GN02" ;;
      st01) BT="$ST01" ;;
      st02) BT="$ST02" ;;
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
