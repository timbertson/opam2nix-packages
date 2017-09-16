world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.epel-release or null) (pkgs."homebrew/science/sundials" or null)
        (pkgs.lapack-devel or null) (pkgs.libsundials-serial-dev or null)
        (pkgs.sundials or null) (pkgs.sundials-devel or null) (pkgs.unzip) ] ++ (lib.attrValues opamDeps));
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
  name = "sundialsml-2.6.2p1";
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
    sha256 = "1avrw7knwya30kfq2h1nw42a3wf9044sqpclhca6lk5jy4f3l6s5";
    url = "https://github.com/inria-parkas/sundialsml/archive/v2.6.2p1.zip";
  };
}

