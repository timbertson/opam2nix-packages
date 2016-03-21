world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_compare = opamSelection.ppx_compare;
      ppx_core = opamSelection.ppx_core;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_driver = opamSelection.ppx_driver;
      ppx_here = opamSelection.ppx_here;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
      sexplib = opamSelection.sexplib;
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
  name = "ppx_assert-113.09.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_assert";
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
    sha256 = "0pvy5a34gbikkjdd44s1sjfz0akzi7l73hfi06wvw0ji47wj4i34";
    url = "https://github.com/janestreet/ppx_assert/archive/113.09.00.tar.gz";
  };
}

