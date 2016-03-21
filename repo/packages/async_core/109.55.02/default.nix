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
      core = opamSelection.core;
      fieldslib = opamSelection.fieldslib;
      herelib = opamSelection.herelib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pa_ounit = opamSelection.pa_ounit;
      pa_test = opamSelection.pa_test;
      sexplib = opamSelection.sexplib;
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
  name = "async_core-109.55.02";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "async_core";
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
    sha256 = "1i7y3f70w58svbldp9b96dzxsg671qd7rkmrfj4317pxrax3x9qm";
    url = "https://ocaml.janestreet.com/ocaml-core/109.55.00/individual/async_core-109.55.02.tar.gz";
  };
}

