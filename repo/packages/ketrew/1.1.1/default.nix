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
      lwt = opamSelection.lwt;
      nonstd = opamSelection.nonstd;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_blob = opamSelection.ppx_blob;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      ppx_include = opamSelection.ppx_include;
      pvem = opamSelection.pvem;
      pvem_lwt_unix = opamSelection.pvem_lwt_unix;
      sosa = opamSelection.sosa;
      sqlite3 = opamSelection.sqlite3;
      ssl = opamSelection.ssl;
      trakeva = opamSelection.trakeva;
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
  name = "ketrew-1.1.1";
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
    sha256 = "1akvia7njy3iv1kbnsm1l51nn6v38djycv8ygjga86wcms5gszhj";
    url = "https://github.com/hammerlab/ketrew/archive/ketrew.1.1.1.tar.gz";
  };
}

