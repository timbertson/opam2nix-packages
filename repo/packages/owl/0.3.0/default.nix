world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-gsl = opamSelection.conf-gsl;
      conf-openblas = opamSelection.conf-openblas;
      ctypes = opamSelection.ctypes;
      dolog = opamSelection.dolog;
      eigen = opamSelection.eigen;
      gsl = opamSelection.gsl;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      plplot = opamSelection.plplot;
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
  name = "owl-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "owl";
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
    sha256 = "1d43qjhr5lcv9ryb515hvg3y3vv75pvlspd7cikkxcl4c17c4yr8";
    url = "https://github.com/ryanrhymes/owl/archive/0.3.0.tar.gz";
  };
}

