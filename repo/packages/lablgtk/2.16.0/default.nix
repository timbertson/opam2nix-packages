world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.expat or null) (pkgs.gtk or null) (pkgs.libexpat1-dev or null)
        (pkgs."libgtk2.0-dev" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlp4 = opamSelection.camlp4;
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
  name = "lablgtk-2.16.0";
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
    sha256 = "0byyfyvl3p996g304bw0ax1w7m1rygzhhi4iqb7ssz95xd99gsm0";
    url = "https://forge.ocamlcore.org/frs/download.php/979/lablgtk-2.16.0.tar.gz";
  };
}

