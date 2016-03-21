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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "why3-base-0.87.0";
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
    sha256 = "0c3vhcb70ay7iwvmq0m25fqh38y40c5x7mki4r9pxf13vgbs3xb0";
    url = "https://gforge.inria.fr/frs/download.php/file/35643/why3-0.87.0.tar.gz";
  };
}

