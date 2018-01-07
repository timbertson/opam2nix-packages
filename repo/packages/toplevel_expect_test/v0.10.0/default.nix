world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-threads = opamSelection.base-threads;
      core_kernel = opamSelection.core_kernel;
      jbuilder = opamSelection.jbuilder;
      mlt_parser = opamSelection.mlt_parser;
      ocaml = opamSelection.ocaml;
      ocaml-compiler-libs = opamSelection.ocaml-compiler-libs;
      ocaml-migrate-parsetree = opamSelection.ocaml-migrate-parsetree;
      ocamlfind = opamSelection.ocamlfind;
      ppx_core = opamSelection.ppx_core;
      ppx_driver = opamSelection.ppx_driver;
      ppx_expect = opamSelection.ppx_expect;
      ppx_here = opamSelection.ppx_here;
      ppx_jane = opamSelection.ppx_jane;
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
  name = "toplevel_expect_test-v0.10.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "toplevel_expect_test";
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
    sha256 = "16x5939ygay0z66ahzzbxqfbdpmzgvcmm9p4xf1lvb3m1sd8n5fl";
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/toplevel_expect_test-v0.10.0.tar.gz";
  };
}

