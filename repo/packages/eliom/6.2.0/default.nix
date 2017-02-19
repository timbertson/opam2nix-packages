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
      dbm = opamSelection.dbm or null;
      deriving = opamSelection.deriving;
      ipaddr = opamSelection.ipaddr;
      js_of_ocaml = opamSelection.js_of_ocaml;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocsigenserver = opamSelection.ocsigenserver;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_tools = opamSelection.ppx_tools;
      reactiveData = opamSelection.reactiveData;
      sqlite3 = opamSelection.sqlite3 or null;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "eliom-6.2.0";
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
    sha256 = "01c4l982ld6d1ndhb6f15ldb2li7mv0bs279d5gs99mpiwsapadx";
    url = "https://github.com/ocsigen/eliom/archive/6.2.0.tar.gz";
  };
}

