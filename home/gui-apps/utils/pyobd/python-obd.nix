{ pkgs, ... }:

with pkgs;

let
  pythonPackages = python3Packages;
in
pythonPackages.buildPythonPackage rec {
  pname = "python-obd";
  version = "0.7.1";

  src = fetchgit {
    url = "https://github.com/brendan-w/python-OBD.git";
    rev = "v0.7.1";
    sha256 = "sha256-4zimyDb+EXe6VG/aLY+N2jTvNnaNtS3K/PNAPPj5wao=";
  };

  propagatedBuildInputs = with pythonPackages; [
    pyserial
  ];

  meta = with lib; {
    description = "Python library for communicating with OBD-II ports";
    homepage = "https://github.com/brendan-w/python-OBD";
    license = licenses.gpl2;
  };
}
