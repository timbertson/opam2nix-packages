world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async_shell = opamSelection.async_shell;
      cmdliner = opamSelection.cmdliner;
      core = opamSelection.core;
      core_extended = opamSelection.core_extended;
      extunix = opamSelection.extunix;
      fileutils = opamSelection.fileutils;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_bin_prot = opamSelection.ppx_bin_prot;
      ppx_compare = opamSelection.ppx_compare;
      ppx_fields_conv = opamSelection.ppx_fields_conv;
      ppx_here = opamSelection.ppx_here;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "oci-0.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "oci";
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
    sha256 = "05syg00w3h6zq4pcj0pbhbq2kmx656mk8731yrj718xa177kis6x";
    url = "https://github.com/bobot/oci/releases/download/0.3/oci-0.3.tar.gz";
  };
}

