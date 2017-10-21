world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."homebrew/science/sundials" or null)
        (pkgs.libsundials-serial-dev or null) (pkgs.sundials or null)
        (pkgs.unzip) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bigarray = opamSelection.base-bigarray;
      mpi = opamSelection.mpi or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "sundialsml-2.5.0p2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sundialsml";
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
    sha256 = "0cchbm4fylrylqh5x436y8xxl3mz84aj6wpxv0pljwkivvf8kvh3";
    url = "https://github.com/inria-parkas/sundialsml/archive/v2.5.0p2.zip";
  };
}

