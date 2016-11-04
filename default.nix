{ pkgs ? import <nixpkgs> {}, stdenv, python3}:

let 
  pythonEnv = python3.withPackages(ps: [ps.systemd]);
  script = ./shutter.py;
in stdenv.mkDerivation {
  name = "shutter";
  propagatedBuildInputs = [pythonEnv];
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup

    mkdir -p $out/bin
    cp ${script} $out/bin/shutter
    substituteInPlace $out/bin/shutter \
      --replace "#!/usr/bin/" "#!${pythonEnv}/bin/"
    chmod a+x $out/bin/shutter
  '';
}
