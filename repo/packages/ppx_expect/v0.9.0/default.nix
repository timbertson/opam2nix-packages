world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocaml-migrate-parsetree = opamSelection.ocaml-migrate-parsetree;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_assert = opamSelection.ppx_assert;
      ppx_compare = opamSelection.ppx_compare;
      ppx_core = opamSelection.ppx_core;
      ppx_custom_printf = opamSelection.ppx_custom_printf;
      ppx_driver = opamSelection.ppx_driver;
      ppx_fields_conv = opamSelection.ppx_fields_conv;
      ppx_here = opamSelection.ppx_here;
      ppx_inline_test = opamSelection.ppx_inline_test;
      ppx_metaquot = opamSelection.ppx_metaquot;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_traverse = opamSelection.ppx_traverse;
      ppx_variants_conv = opamSelection.ppx_variants_conv;
      re = opamSelection.re;
      stdio = opamSelection.stdio;
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
  name = "ppx_expect-v0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_expect";
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
    sha256 = "1aw3kl648wkiqr1s4yhjz86ddfv2k4bp81wsar0s39a9lw6rfcfw";
    url = "http://ocaml.janestreet.com/ocaml-core/v0.9/files/ppx_expect-v0.9.0.tar.gz";
  };
}

