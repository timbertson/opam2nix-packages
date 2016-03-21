world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      conduit = opamSelection.conduit;
      docout = opamSelection.docout;
      js_of_ocaml = opamSelection.js_of_ocaml;
      lwt = opamSelection.lwt;
      nonstd = opamSelection.nonstd;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlify = opamSelection.ocamlify;
      omake = opamSelection.omake;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      pvem = opamSelection.pvem;
      pvem_lwt_unix = opamSelection.pvem_lwt_unix;
      reactiveData = opamSelection.reactiveData;
      sosa = opamSelection.sosa;
      sqlite3 = opamSelection.sqlite3;
      ssl = opamSelection.ssl;
      trakeva = opamSelection.trakeva;
      tyxml = opamSelection.tyxml;
      uri = opamSelection.uri;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ketrew-2.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ketrew";
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
    sha256 = "0whv1ixxgvdrqr8d5yz7pxcxf0xwbqzs1jqaikq505idwpm50hcd";
    url = "https://github.com/hammerlab/ketrew/archive/ketrew.2.0.0.tar.gz";
  };
}

