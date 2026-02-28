{
  config,
  lib,
  pkgs,
  ...
}:
let
  f =
    {
      buildPythonPackage,
      evdev,
      buildtools,
      lib,
    }:
    buildPythonPackage {
      name = "rockpi-penta";
      version = "0.2.2";

      src = lib.fetchgit {
        url = "https://github.com/radxa/rockpi-penta.git";
        rev = "v0.2.2";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };

      format = "pyproject";
      propagatedBuildInputs = with pkgs; [
        Adafruit-Blinka
        adafruit-circuitpython-busdevice
        adafruit-circuitpython-connectionmanager
        adafruit-circuitpython-framebuf
        adafruit-circuitpython-requests
        adafruit-circuitpython-ssd1306
        adafruit-circuitpython-typing
        Adafruit-PlatformDetect
        Adafruit-PureIO
        pyftdi
        pyserial
        pyusb
        typing-extensions
      ];

      meta = {
        description = ''
          Disconnect idle PS3/PS4 Bluetooth controllers
        '';
      };
    };

  rockpi-penta = pkgs.callPackage ./default.nix { };
  cfg = config.services.monitor-controllers;
in
{

  # hardware.raspberry-pi.extra-config = ''
  #   do_i2c=0
  # '';

}
