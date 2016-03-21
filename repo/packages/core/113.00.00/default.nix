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
      core_kernel = opamSelection.core_kernel;
      custom_printf = opamSelection.custom_printf;
      enumerate = opamSelection.enumerate;
      fieldslib = opamSelection.fieldslib;
      herelib = opamSelection.herelib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pa_bench = opamSelection.pa_bench;
      pa_ounit = opamSelection.pa_ounit;
      pa_structural_sexp = opamSelection.pa_structural_sexp;
      pa_test = opamSelection.pa_test;
      pipebang = opamSelection.pipebang;
      sexplib = opamSelection.sexplib;
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
  name = "core-113.00.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "core";
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
    sha256 = "1wxp461av6fj85yvsnripjdinspkjhcybdrnpnrg7vn76y198vsx";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/core-113.00.00.tar.gz";
  };
}

