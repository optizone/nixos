{ pkgs, config, ... }:
let
  goodix-gt7868q = config.boot.kernelPackages.callPackage ./goodix-gt7868q.nix { };
in
{
  imports = [
    ../laptop-common/default.nix
    ./hardware-configuration.nix

    ./user.nix

    ../../core/services/lubelogger.nix
    ../../core/services/smb.nix
  ];

  programs.winbox = {
    enable = true;
    openFirewall = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
    [Lenovo Thinkbook G6+ IMH - Goodix GT7868Q]
    MatchDMIModalias=dmi:bvnLENOVO:*:pvrThinkBook*G6+IMH*:*
    MatchVendor=0x27C6
    MatchProduct=0x01E9

    #AttrEventCode=-ABS_MT_PRESSURE;-ABS_PRESSURE;
    AttrPressureRange=2:0
    AttrPalmPressureThreshold=600
    AttrThumbPressureThreshold=1000
  '';

  boot = {
    extraModulePackages = [ goodix-gt7868q ];
  };
}
