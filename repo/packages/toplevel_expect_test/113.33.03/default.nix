world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bin_prot = opamSelection.bin_prot;
      core_kernel = opamSelection.core_kernel;
      fieldslib = opamSelection.fieldslib;
      js-build-tools = opamSelection.js-build-tools;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_assert = opamSelection.ppx_assert;
      ppx_bench = opamSelection.ppx_bench;
      ppx_core = opamSelection.ppx_core;
      ppx_driver = opamSelection.ppx_driver;
      ppx_expect = opamSelection.ppx_expect;
      ppx_here = opamSelection.ppx_here;
      ppx_inline_test = opamSelection.ppx_inline_test;
      ppx_jane = opamSelection.ppx_jane;
      sexplib = opamSelection.sexplib;
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
  name = "toplevel_expect_test-113.33.03";
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
    sha256 = "0fz9g4952pbg8rs4381dkiq4g56i1yi9qi1dlsk3idlyp8zg4abd";
    url = "https://ocaml.janestreet.com/ocaml-core/113.33/files/toplevel_expect_test-113.33.03.tar.gz";
  };
}

