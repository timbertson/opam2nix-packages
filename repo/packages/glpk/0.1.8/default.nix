world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."homebrew/science/glpk" or null) (pkgs.libglpk-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
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
  name = "glpk-0.1.8";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "glpk";
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
    sha256 = "0ai7kcx3fbprkc14xv1wzqvjmi8xnkixyzrhpf1pklkb1ynddhqc";
    url = "https://github.com/smimram/ocaml-glpk/releases/download/0.1.8/ocaml-glpk-0.1.8.tar.gz";
  };
}

