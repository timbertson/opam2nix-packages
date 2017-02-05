world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ctypes = opamSelection.ctypes;
      ctypes-foreign = opamSelection.ctypes-foreign;
      hardcaml = opamSelection.hardcaml;
      llvm = opamSelection.llvm;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
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
  name = "hardcaml-llvmsim-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "hardcaml-llvmsim";
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
    sha256 = "04paj6w28dba11g35nqf3w8xcq7bqwf4fpx9s4pxv995i62hlk7y";
    url = "https://github.com/ujamjar/hardcaml-llvmsim/archive/v0.3.0.tar.gz";
  };
}

