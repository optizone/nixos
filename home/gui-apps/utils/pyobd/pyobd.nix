{ pkgs, ... }:

with pkgs;

let
  pythonPackages = python3Packages;
  pythonDeps = with pythonPackages; [
    pygobject3
    dbus-python
    pycairo
    pyserial
    wxpython
    numpy
    tornado
    pint
    pillow
    six
  ];

  pyobd = stdenv.mkDerivation {
    pname = "pyobd";
    version = "1.19";

    src = fetchgit {
      url = "https://github.com/barracuda-fsh/pyobd.git";
      rev = "d98420a81463073661022640d10d5faf6e602b8e";
      sha256 = "sha256-JO60TibE0rzrZln1lyFXt6ZGGuAl236N8pIn6Lh32Sc=";
    };

    nativeBuildInputs = [
      makeWrapper
    ];

    buildInputs = [
      pythonPackages.python
    ]
    ++ pythonDeps;

    installPhase = ''
      install -d $out/libexec/pyobd
      cp -r $src/* $out/libexec/pyobd/

      makeWrapper ${pythonPackages.python}/bin/python $out/bin/pyobd \
        --add-flags $out/libexec/pyobd/pyobd.py \
        --run "cd $out/libexec/pyobd/" \
        --prefix PYTHONPATH : "${with pythonPackages; makePythonPath pythonDeps}"
    '';

    meta = with lib; {
      description = "A Python OBD-II tool for diagnostics and data logging";
      homepage = "https://github.com/barracuda-fsh/pyobd";
      license = licenses.gpl2;
      maintainers = [ ];
      platforms = platforms.linux;
    };
  };
in
{
  home.packages = [ pyobd ];
}
