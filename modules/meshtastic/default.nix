{
  config,
  pkgs,
  username,
  ...
}: let
  zcontact = pkgs.writeShellScriptBin "zcontact" ''
    nodes=$(mnodes -l)
    options="''${nodes//$' '/$'\n'}"
    [ -z "$1" ] && \
      dev=$(echo "$options" | rofi -dmenu -theme-str 'window {width: 10%;} listview {columns: 1;}') || \
      dev="$1"

    [ -z "$dev" ] && exit 0

    contact --ble "$(mnodes --ble $dev)"
  '';

  mnodes = pkgs.writeShellScriptBin "mnodes" ''
    declare -rA node_to_ble=(
      [gn01]="8C:FD:49:B5:D8:15"
      [gn02]="E8:F6:0A:CB:1A:09"
      [st01]="ED:96:E1:99:09:20"
      [st02]="C7:80:90:01:30:2E"
    )

    declare -rA node_to_config=(
      [gn01]="${builtins.readFile ./nodes/gn01.yaml}"
      [gn02]="${builtins.readFile ./nodes/gn02.yaml}"
      [st01]="${builtins.readFile ./nodes/st01.yaml}"
      [st02]="${builtins.readFile ./nodes/st02.yaml}"
    )

    usage() {
      echo "mnodes [--configure|-c <NODE>] [--print|-p <NODE>] [--ble|-b <NODE>] [--list|-l] [--help|-h]"
      echo
      echo "  Avaliable nodes: ''${!node_to_ble[@]}"
      echo
      echo "  --configure: loads configuration to the provided node"
      echo "  --print: prints information about provided node"
      echo "  --ble: prints bluetooth MAC address of the provided node"
      echo "  --list: prints all avaliable nodes"
      echo "  --help: prints this message"
      exit $1
    }

    while [ $# -gt 0 ]; do
      case "$1" in
        "-p" | "--print")
          [ $# -lt 2 ] && usage 1
          print=true
          node="$2"
          shift 2
          ;;

        "-b" | "--ble")
          [ $# -lt 2 ] && usage 1
          bluetooth=true
          node="$2"
          shift 2
          ;;

        "-c" | "--configure")
          [ $# -lt 2 ] && usage 1
          configure=true
          node="$2"
          shift 2
          ;;

        "-h" | "--help")
          usage 0
          ;;

        "-l" | "--list")
          echo "''${!node_to_ble[@]}"
          exit 0
          ;;

        *)
          usage 1
          ;;
      esac
    done

    if [[ ! -v node_to_ble[$node] ]]; then
      usage 1
    fi

    username=$(cat ${config.sops.secrets."mnodes/mqtt/username".path})
    password=$(cat ${config.sops.secrets."mnodes/mqtt/password".path})
    fixedPin=$(cat ${config.sops.secrets."mnodes/bluetooth-pin".path})
    channel_url=$(cat ${config.sops.secrets."mnodes/channel-url".path})

    ble="''${node_to_ble[$node]}"
    config="''${node_to_config[$node]}"
    privateKey=$(cat "/run/secrets/mnodes/private-key/$node")

    if [ "$configure" = true ]; then
      tmp=$(mktemp)
      echo "$config" > tmp
      meshtastic --configure "$tmp" --ble "$ble"
      rm "$tmp"
    elif [ "$print" = true ]; then
      echo "NODE: $node"
      echo "BLE: $ble"
      echo "CONFIG: "
      echo "$config"
    elif [ "$bluetooth" = true ]; then
      echo "$ble"
    fi

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
