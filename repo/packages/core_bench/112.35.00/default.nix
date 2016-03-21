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
      camlp4 = opamSelection.camlp4;
      comparelib = opamSelection.comparelib;
      core = opamSelection.core;
      fieldslib = opamSelection.fieldslib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      pa_ounit = opamSelection.pa_ounit;
      sexplib = opamSelection.sexplib;
      textutils = opamSelection.textutils;
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
  name = "core_bench-112.35.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "core_bench";
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
    sha256 = "0d9mffdn06a03ab8bd7igghys2kz2d6k4ff5b2a8bs8jhh3jbsf2";
    url = "https://ocaml.janestreet.com/ocaml-core/112.35/files/core_bench-112.35.00.tar.gz";
  };
}

