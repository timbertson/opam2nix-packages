world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.fftw or null) (pkgs.fftw-devel or null)
        (pkgs.libfftw3-dev or null) (pkgs."math/fftw3" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      archimedes = opamSelection.archimedes or null;
      base = opamSelection.base;
      configurator = opamSelection.configurator;
      cppo = opamSelection.cppo;
      jbuilder = opamSelection.jbuilder;
      lacaml = opamSelection.lacaml or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      stdio = opamSelection.stdio;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "fftw3-0.8";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "fftw3";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "15gbpp3wvfi7ly3q4n2sad9khf6sgns2mx0g1mihazg0vzgjsk5g";
    url = "https://github.com/Chris00/fftw-ocaml/releases/download/0.8/fftw3-0.8.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

