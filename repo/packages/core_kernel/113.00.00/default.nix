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
      custom_printf = opamSelection.custom_printf;
      enumerate = opamSelection.enumerate;
      fieldslib = opamSelection.fieldslib;
      herelib = opamSelection.herelib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pa_bench = opamSelection.pa_bench;
      pa_ounit = opamSelection.pa_ounit;
      pa_test = opamSelection.pa_test;
      pipebang = opamSelection.pipebang;
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
  name = "core_kernel-113.00.00";
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
    sha256 = "14dizq3clkrq535gjmamv241v2fpv9yk6yn31b4wxgshqis3wb80";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/core_kernel-113.00.00.tar.gz";
  };
}

