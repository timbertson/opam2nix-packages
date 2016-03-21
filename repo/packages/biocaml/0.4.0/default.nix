world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      camlzip = opamSelection.camlzip;
      cfstream = opamSelection.cfstream;
      core = opamSelection.core;
      future = opamSelection.future;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      omake = opamSelection.omake;
      ounit = opamSelection.ounit;
      ppx_compare = opamSelection.ppx_compare;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      re = opamSelection.re;
      sexplib = opamSelection.sexplib;
      uri = opamSelection.uri;
      xmlm = opamSelection.xmlm;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "biocaml-0.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "biocaml";
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
    sha256 = "0y4avv5jlmvlpp10kxq04zy8rcm40l9wgcrdklh79b096ks8sma6";
    url = "https://github.com/biocaml/biocaml/archive/v0.4.0.tar.gz";
  };
}

