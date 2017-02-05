world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libgles2-mesa-dev or null) (pkgs.libmesaglesv2_2-devel or null)
        (pkgs.mesa-libGLES or null) (pkgs.mesa-libGLES-devel or null) ] ++ (lib.attrValues opamDeps));
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
  name = "gles3-20160307.alpha";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "gles3";
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
    sha256 = "1jggbn5vfgibq52xffydf8qf1lsg3fv635wqxpcwcr294r528q67";
    url = "https://lama.univ-savoie.fr/~raffalli/gles3/gles3-20160307.alpha.tar.gz";
  };
}

