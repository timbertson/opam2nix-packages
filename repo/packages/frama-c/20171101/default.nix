world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alt-ergo = opamSelection.alt-ergo;
      altgr-ergo = opamSelection.altgr-ergo or null;
      conf-autoconf = opamSelection.conf-autoconf;
      conf-gnomecanvas = opamSelection.conf-gnomecanvas;
      conf-gtksourceview = opamSelection.conf-gtksourceview;
      coq = opamSelection.coq or null;
      lablgtk = opamSelection.lablgtk;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlgraph = opamSelection.ocamlgraph;
      why3 = opamSelection.why3 or null;
      zarith = opamSelection.zarith;
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
  name = "frama-c-20171101";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "frama-c";
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
    sha256 = "1vwjfqmm1r36gkybsy3a7m89q5zicf4rnz5vlsn9imnpjpl9gjw1";
    url = "http://frama-c.com/download/frama-c-Sulfur-20171101.tar.gz";
  };
}

