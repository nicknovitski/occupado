{ stdenv ? (import <nixpkgs> {}).stdenv
, python3 ? (import <nixpkgs> {}).python3
}:

let 
  pythonEnv = python3.withPackages(ps: [ps.systemd]);
  script = ./occupado;
in stdenv.mkDerivation {
  name = "occupado";
  propagatedBuildInputs = [pythonEnv];
  
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${script} $out/bin/occupado
  '';
}
