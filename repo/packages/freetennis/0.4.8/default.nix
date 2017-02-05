world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.freeglut3-dev or null) (pkgs."libgtk2.0-dev" or null)
        (pkgs."libsdl-gfx1.2-dev" or null)
        (pkgs."libsdl-image1.2-dev" or null)
        (pkgs."libsdl-mixer1.2-dev" or null)
        (pkgs."libsdl-ttf2.0-dev" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlimages = opamSelection.camlimages;
      lablgl = opamSelection.lablgl;
      lablgtk = opamSelection.lablgtk;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlsdl = opamSelection.ocamlsdl;
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
  name = "freetennis-0.4.8";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "freetennis";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1gxy4vj5f4zvjg9d2hawjji1c02plj2rz7bsv3sbwnyfr78n6ihd";
    url = "http://downloads.sourceforge.net/project/freetennis/freetennis/0.4.8/freetennis-0.4.8.tar.bz2";
  };
}

