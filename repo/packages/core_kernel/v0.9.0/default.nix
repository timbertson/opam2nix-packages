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
      bin_prot = opamSelection.bin_prot;
      configurator = opamSelection.configurator;
      fieldslib = opamSelection.fieldslib;
      jane-street-headers = opamSelection.jane-street-headers;
      jbuilder = opamSelection.jbuilder;
      num = opamSelection.num;
      ocaml = opamSelection.ocaml;
      ocaml-migrate-parsetree = opamSelection.ocaml-migrate-parsetree;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_assert = opamSelection.ppx_assert;
      ppx_base = opamSelection.ppx_base;
      ppx_driver = opamSelection.ppx_driver;
      ppx_hash = opamSelection.ppx_hash;
      ppx_inline_test = opamSelection.ppx_inline_test;
      ppx_jane = opamSelection.ppx_jane;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_sexp_message = opamSelection.ppx_sexp_message;
      sexplib = opamSelection.sexplib;
      stdio = opamSelection.stdio;
      typerep = opamSelection.typerep;
      variantslib = opamSelection.variantslib;
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
  name = "core_kernel-v0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "core_kernel";
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
    sha256 = "0i8z73shr38hpwil74ksq5ddbxlglz7c838f6cyzywwzjj2cyy3b";
    url = "https://ocaml.janestreet.com/ocaml-core/v0.9/files/core_kernel-v0.9.0.tar.gz";
  };
}

