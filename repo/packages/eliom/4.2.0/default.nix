world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      calendar = opamSelection.calendar;
      camlp4 = opamSelection.camlp4;
      deriving = opamSelection.deriving;
      ipaddr = opamSelection.ipaddr;
      js_of_ocaml = opamSelection.js_of_ocaml;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocsigenserver = opamSelection.ocsigenserver;
      reactiveData = opamSelection.reactiveData;
      tyxml = opamSelection.tyxml;
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
  name = "eliom-4.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "eliom";
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
    sha256 = "0gbqzgn6xgpq6irz2sfr92qj3hjcwl45wy0inc4ps5r15nvq1l9h";
    url = "https://github.com/ocsigen/eliom/archive/4.2.tar.gz";
  };
}

