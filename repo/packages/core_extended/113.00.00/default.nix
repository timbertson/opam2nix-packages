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
      custom_printf = opamSelection.custom_printf;
      fieldslib = opamSelection.fieldslib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pa_ounit = opamSelection.pa_ounit;
      pa_test = opamSelection.pa_test;
      pipebang = opamSelection.pipebang;
      re2 = opamSelection.re2;
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
  name = "core_extended-113.00.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "core_extended";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1fj9hk6b44qskdmgfydf1a7vy4a3l9177nnmw45qk746g8hrx936";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/core_extended-113.00.00.tar.gz";
  };
}

