{
  config,
  pkgs,
  username,
  ...
}: let
  common-cfg = node: ''
    channel_url: $(cat ${config.sops.secrets."mnodes/channel-url".path})
    config:
      bluetooth:
        enabled: true
        fixedPin: 123456
      device:
        ledHeartbeatDisabled: true
        nodeInfoBroadcastSecs: 10800
        role: CLIENT
        tzdef: GMT-3
      display:
        screenOnSecs: 600
      lora:
        hopLimit: 3
        ignoreMqtt: true
        region: EU_868
        sx126xRxBoostedGain: true
        txEnabled: true
        txPower: 27
        usePreset: true
      network:
        ntpServer: meshtastic.pool.ntp.org
      position:
        broadcastSmartMinimumDistance: 100
        broadcastSmartMinimumIntervalSecs: 30
        gpsEnGpio: 34
        gpsMode: ENABLED
        gpsUpdateInterval: 120
        positionBroadcastSecs: 900
        positionBroadcastSmartEnabled: true
        positionFlags: 811
      power:
        lsSecs: 300
        minWakeSecs: 10
        sdsSecs: 4294967295
        waitBluetoothSecs: 60
    module_config:
      ambientLighting:
        blue: 8
        current: 10
        green: 26
        red: 203
      cannedMessage:
        enabled: true
      detectionSensor:
        detectionTriggerType: LOGIC_HIGH
        minimumBroadcastSecs: 45
      mqtt:
        address: mqtt.meshtastic.org
        encryptionEnabled: true
        password: large4cats
        root: msh/EU_868
        username: meshdev
      telemetry:
        deviceUpdateInterval: 2147483647
    owner: ${node}
    owner_short: ${node}
  '';

  security-cfg = node: pubkey: ''
    security:
        privateKey: $(cat ${config.sops.secrets."mnodes/${node}/private-key".path})
        publicKey: ${pubkey}
        serialEnabled: true
  '';

  gnxx-cfg = node: pubkey: ''
    ${common-cfg node}
    ${security-cfg node pubkey}
  '';

  nodes-map-entry = node: pubkey: ''
    ["${node}"]="${gnxx-cfg node pubkey}"
  '';
in {
  sops.secrets = {
    "mnodes/channel-url" = {
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };

    "mnodes/gn01/private-key" = {
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };

    "mnodes/gn02/private-key" = {
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };

    "mnodes/st01/private-key" = {
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };

    "mnodes/st02/private-key" = {
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };
  };

  environment.systemPackages = [
    pkgs.contact

    (pkgs.writeShellScriptBin "zcontact" ''
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
    '')

    (pkgs.writeShellScriptBin "mnodes" ''
      node_arg="$1"
      declare -A nodes=(
        ${nodes-map-entry "gn01" "base64:F3HaGNoKXzf7B3p1jOIXT7Bf3fD5hlBOCm/AI1rHZkQ="}
        ${nodes-map-entry "gn02" "base64:DYtARWqcwACDu1+0YuipzPGgE8fYCFY4r17HC0fEKiQ="}
        ${nodes-map-entry "st01" "base64:J1X9UJBc0q1NH7gzXFdfnrAxG62Y6Uc7gHuk5AnpnWs="}
        ${nodes-map-entry "st02" "base64:XLXjuy5e9TvIgL5Aja+V4IWMEOnqU5Z3Dm+FClwiJDk="}
      )

      [ -n "$node_arg" ] && [ -z "''${nodes[$node_arg]}" ] && \
        echo "Unknown node "$node_arg"!" && \
        exit 1

      for node in "''${!nodes[@]}"; do
        if [ -z "$node_arg" ] || [ "$node" == "$node_arg" ]; then
          echo "$node:"
          echo "''${nodes[$node]}"
        fi
      done
    '')
  ];
}
