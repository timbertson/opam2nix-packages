world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      async_find = opamSelection.async_find;
      async_inotify = opamSelection.async_inotify;
      async_shell = opamSelection.async_shell;
      bin_prot = opamSelection.bin_prot;
      camlzip = opamSelection.camlzip;
      core = opamSelection.core;
      core_extended = opamSelection.core_extended;
      fieldslib = opamSelection.fieldslib;
      js-build-tools = opamSelection.js-build-tools;
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
      textutils = opamSelection.textutils;
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
  name = "async_extended-113.33.03";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "async_extended";
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
    sha256 = "0a49n9g580i8xwq8p109zsy0d450wj24mfkpyva50fsryh6nfb0f";
    url = "https://ocaml.janestreet.com/ocaml-core/113.33/files/async_extended-113.33.03.tar.gz";
  };
}

