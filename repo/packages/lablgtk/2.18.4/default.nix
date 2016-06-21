world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.expat or null) (pkgs.gtk or null) (pkgs."gtk+2.0-dev" or null)
        (pkgs.gtk2-devel or null) (pkgs.libexpat1-dev or null)
        (pkgs."libgtk2.0-dev" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-glade = opamSelection.conf-glade or null;
      conf-gnomecanvas = opamSelection.conf-gnomecanvas or null;
      conf-gtksourceview = opamSelection.conf-gtksourceview or null;
      lablgl = opamSelection.lablgl or null;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "lablgtk-2.18.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "lablgtk";
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
    sha256 = "1h0ks2iy6ns4jcmzx875mi7v2sia7h5amphv1nmw2q77j85sw5mk";
    url = "https://forge.ocamlcore.org/frs/download.php/1602/lablgtk-2.18.4.tar.gz";
  };
}

