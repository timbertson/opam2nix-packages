world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocaml-migrate-parsetree = opamSelection.ocaml-migrate-parsetree;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_assert = opamSelection.ppx_assert;
      ppx_base = opamSelection.ppx_base;
      ppx_bench = opamSelection.ppx_bench;
      ppx_bin_prot = opamSelection.ppx_bin_prot;
      ppx_custom_printf = opamSelection.ppx_custom_printf;
      ppx_driver = opamSelection.ppx_driver;
      ppx_expect = opamSelection.ppx_expect;
      ppx_fail = opamSelection.ppx_fail;
      ppx_fields_conv = opamSelection.ppx_fields_conv;
      ppx_here = opamSelection.ppx_here;
      ppx_inline_test = opamSelection.ppx_inline_test;
      ppx_let = opamSelection.ppx_let;
      ppx_optional = opamSelection.ppx_optional;
      ppx_pipebang = opamSelection.ppx_pipebang;
      ppx_sexp_message = opamSelection.ppx_sexp_message;
      ppx_sexp_value = opamSelection.ppx_sexp_value;
      ppx_typerep_conv = opamSelection.ppx_typerep_conv;
      ppx_variants_conv = opamSelection.ppx_variants_conv;
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
  name = "ppx_jane-v0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_jane";
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
    sha256 = "13dzqyggf196cv3wl6r3iggf701amhl31zn54507zn4z8dsg151k";
    url = "https://ocaml.janestreet.com/ocaml-core/v0.9/files/ppx_jane-v0.9.0.tar.gz";
  };
}

