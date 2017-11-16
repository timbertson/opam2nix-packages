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
      ppx_assert = opamSelection.ppx_assert;
      ppx_bench = opamSelection.ppx_bench;
      ppx_bin_prot = opamSelection.ppx_bin_prot;
      ppx_compare = opamSelection.ppx_compare;
      ppx_custom_printf = opamSelection.ppx_custom_printf;
      ppx_driver = opamSelection.ppx_driver;
      ppx_enumerate = opamSelection.ppx_enumerate;
      ppx_expect = opamSelection.ppx_expect;
      ppx_fail = opamSelection.ppx_fail;
      ppx_fields_conv = opamSelection.ppx_fields_conv;
      ppx_here = opamSelection.ppx_here;
      ppx_inline_test = opamSelection.ppx_inline_test;
      ppx_let = opamSelection.ppx_let;
      ppx_pipebang = opamSelection.ppx_pipebang;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_sexp_message = opamSelection.ppx_sexp_message;
      ppx_sexp_value = opamSelection.ppx_sexp_value;
      ppx_type_conv = opamSelection.ppx_type_conv;
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
  name = "ppx_jane-113.24.00";
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
    sha256 = "1v9rns6a6mq63ifk60anpk1k11bcavj7h66w43bpgi8qvcbgnjaa";
    url = "https://ocaml.janestreet.com/ocaml-core/113.24/files/ppx_jane-113.24.00.tar.gz";
  };
}

