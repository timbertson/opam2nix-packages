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
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_assert = opamSelection.ppx_assert;
      ppx_bench = opamSelection.ppx_bench;
      ppx_driver = opamSelection.ppx_driver;
      ppx_expect = opamSelection.ppx_expect;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "async_kernel-113.24.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "async_kernel";
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
    sha256 = "0mj5c79rfi19sylmjqlqvj5y3i470b11kaafvpfy02x9jf71p2af";
    url = "https://ocaml.janestreet.com/ocaml-core/113.24/files/async_kernel-113.24.00.tar.gz";
  };
}

