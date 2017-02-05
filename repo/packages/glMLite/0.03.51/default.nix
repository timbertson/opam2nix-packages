world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.freeglut3-dev or null) (pkgs."homebrew/x11/freeglut" or null) ] ++ (lib.attrValues opamDeps));
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
  name = "glMLite-0.03.51";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "glMLite";
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
    sha256 = "1wkb692b588ws989xrll3asmsd04n2yk76qjxcslqscik4f9bx1k";
    url = "http://www.linux-nantes.org/~fmonnier/OCaml/GL/download/glMLite-0.03.51.tgz";
  };
}

