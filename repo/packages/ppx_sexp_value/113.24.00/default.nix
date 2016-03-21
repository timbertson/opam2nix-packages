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
      ppx_core = opamSelection.ppx_core;
      ppx_driver = opamSelection.ppx_driver;
      ppx_here = opamSelection.ppx_here;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
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
  name = "ppx_sexp_value-113.24.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_sexp_value";
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
    sha256 = "13d8903qi4ifk1pczw17vrn4x64gi2xib0z73dllgskmf237r01z";
    url = "https://ocaml.janestreet.com/ocaml-core/113.24/files/ppx_sexp_value-113.24.00.tar.gz";
  };
}

