{ stdenv ? (import <nixpkgs> {}).stdenv
, python3 ? (import <nixpkgs> {}).python3
}:

let 
  pythonEnv = python3.withPackages(ps: [ps.systemd]);
  script = ./shutter.py;
in stdenv.mkDerivation {
  name = "shutter";
  propagatedBuildInputs = [pythonEnv];
  
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${script} $out/bin/shutter
  '';
}
