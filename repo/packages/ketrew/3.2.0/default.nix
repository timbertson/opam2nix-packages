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
      lwt_react = opamSelection.lwt_react;
      nonstd = opamSelection.nonstd;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlify = opamSelection.ocamlify;
      postgresql = opamSelection.postgresql or null;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      pvem = opamSelection.pvem;
      pvem_lwt_unix = opamSelection.pvem_lwt_unix;
      reactiveData = opamSelection.reactiveData;
      solvuu-build = opamSelection.solvuu-build;
      sosa = opamSelection.sosa;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ketrew-3.2.0";
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
    sha256 = "0397qx7g14z5ir4b2k6fv7ajxyxrp6nz1kz6q1z8id5whsm4k9br";
    url = "https://github.com/hammerlab/ketrew/archive/ketrew.3.2.0.tar.gz";
  };
}

