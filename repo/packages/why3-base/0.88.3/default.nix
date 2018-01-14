world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlzip = opamSelection.camlzip or null;
      conf-gtksourceview = opamSelection.conf-gtksourceview or null;
      coq = opamSelection.coq or null;
      lablgtk = opamSelection.lablgtk or null;
      menhir = opamSelection.menhir;
      num = opamSelection.num;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlgraph = opamSelection.ocamlgraph or null;
      zarith = opamSelection.zarith or null;
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
  name = "why3-base-0.88.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "why3-base";
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
    sha256 = "0limdqy9l5bjzwhdalcfdyh0b6laxgiphhvr4bby9p0030agssiy";
    url = "https://gforge.inria.fr/frs/download.php/file/37313/why3-0.88.3.tar.gz";
  };
}

