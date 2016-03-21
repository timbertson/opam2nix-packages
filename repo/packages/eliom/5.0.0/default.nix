world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      base-no-ppx = opamSelection.base-no-ppx or null;
      calendar = opamSelection.calendar;
      camlp4 = opamSelection.camlp4;
      deriving = opamSelection.deriving;
      ipaddr = opamSelection.ipaddr;
      js_of_ocaml = opamSelection.js_of_ocaml;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocsigenserver = opamSelection.ocsigenserver;
      ppx_tools = opamSelection.ppx_tools or null;
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
  name = "eliom-5.0.0";
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
    sha256 = "1g9wq2qpn0sgzyb6iq0h9afq5p68il4h8pc7jppqsislk87m09k7";
    url = "https://github.com/ocsigen/eliom/archive/5.0.0.tar.gz";
  };
}

