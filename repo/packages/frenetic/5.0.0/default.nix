world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.unzip) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      async_extended = opamSelection.async_extended;
      base64 = opamSelection.base64;
      cohttp = opamSelection.cohttp;
      cohttp-async = opamSelection.cohttp-async;
      core = opamSelection.core;
      cppo = opamSelection.cppo;
      cstruct = opamSelection.cstruct;
      cstruct-async = opamSelection.cstruct-async;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      menhir = opamSelection.menhir;
      mparser = opamSelection.mparser;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlgraph = opamSelection.ocamlgraph;
      odoc = opamSelection.odoc;
      ppx_compare = opamSelection.ppx_compare;
      ppx_core = opamSelection.ppx_core;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_driver = opamSelection.ppx_driver;
      ppx_enumerate = opamSelection.ppx_enumerate;
      ppx_fields_conv = opamSelection.ppx_fields_conv;
      ppx_metaquot = opamSelection.ppx_metaquot;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools_versioned = opamSelection.ppx_tools_versioned;
      sedlex = opamSelection.sedlex;
      sexplib = opamSelection.sexplib;
      tcpip = opamSelection.tcpip;
      yojson = opamSelection.yojson;
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
  name = "frenetic-5.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "frenetic";
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
    sha256 = "0l0qlk849sfkncrgkc305gvsjddmgvi8l3l97xvj8c1mdwxwgm3n";
    url = "https://github.com/frenetic-lang/frenetic/archive/v5.0.0.zip";
  };
}

