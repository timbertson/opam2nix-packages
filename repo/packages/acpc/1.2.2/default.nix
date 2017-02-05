world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-unix = opamSelection.base-unix;
      batteries = opamSelection.batteries;
      conf-autoconf = opamSelection.conf-autoconf;
      conf-gnuplot = opamSelection.conf-gnuplot;
      dolog = opamSelection.dolog;
      itv-tree = opamSelection.itv-tree;
      lacc = opamSelection.lacc;
      obuild = opamSelection.obuild;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlgraph = opamSelection.ocamlgraph;
      parmap = opamSelection.parmap;
      vector3 = opamSelection.vector3;
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
  name = "acpc-1.2.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "acpc";
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
    sha256 = "1z13v65m6rlc2nm11f1ldsx8brjb9hyjxzv14rd3q8145sqchg74";
    url = "https://github.com/UnixJunkie/ACPC/archive/v1.2.2.tar.gz";
  };
}

