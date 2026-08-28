{
  config,
  pkgs,
  username,
  ...
}: let
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

  mnodes = pkgs.writeShellScriptBin "mnodes" ''
    node="$1"

    username=$(cat ${config.sops.secrets."mnodes/mqtt/username".path})
    password=$(cat ${config.sops.secrets."mnodes/mqtt/password".path})
    fixedPin=$(cat ${config.sops.secrets."mnodes/bluetooth-pin".path})

    gn01() {
      privateKey=$(cat ${config.sops.secrets."mnodes/private-key/gn01".path})
      conf="${builtins.readFile ./nodes/gn01.yaml}"
      echo "$conf"
    }

    gn02() {
      privateKey=$(cat ${config.sops.secrets."mnodes/private-key/gn02".path})
      conf='${builtins.readFile ./nodes/gn02.yaml}'
      echo "$conf"
    }

    st01() {
      privateKey=$(cat ${config.sops.secrets."mnodes/private-key/st01".path})
      conf='${builtins.readFile ./nodes/st01.yaml}'
      echo "$conf"
    }

    st02() {
      privateKey=$(cat ${config.sops.secrets."mnodes/private-key/st02".path})
      conf='${builtins.readFile ./nodes/st02.yaml}'
      echo "$conf"
    }

    [ -z "$node" ] || [ "$node" = "gn01" ] && gn01
    [ -z "$node" ] || [ "$node" = "gn02" ] && gn02
    [ -z "$node" ] || [ "$node" = "st01" ] && st01
    [ -z "$node" ] || [ "$node" = "st02" ] && st02

  '';
in {
  sops.secrets = let
    owner = config.users.users.${username}.name;
    group = config.users.users.${username}.group;
  in {
    "mnodes/channel-url" = {inherit owner group;};
    "mnodes/private-key/gn01" = {inherit owner group;};
    "mnodes/private-key/gn02" = {inherit owner group;};
    "mnodes/private-key/st01" = {inherit owner group;};
    "mnodes/private-key/st02" = {inherit owner group;};
    "mnodes/bluetooth-pin" = {inherit owner group;};
    "mnodes/mqtt/username" = {inherit owner group;};
    "mnodes/mqtt/password" = {inherit owner group;};
  };

  environment.systemPackages = with pkgs; [
    contact
    meshtastic
    zcontact
    mnodes
  ];
}
