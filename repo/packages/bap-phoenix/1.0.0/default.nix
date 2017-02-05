world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bap-std = opamSelection.bap-std;
      cmdliner = opamSelection.cmdliner;
      ezjsonm = opamSelection.ezjsonm;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlgraph = opamSelection.ocamlgraph;
      text-tags = opamSelection.text-tags;
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
  name = "bap-phoenix-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "bap-phoenix";
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
    sha256 = "1apfzxndysy92bz5g0dslfmfcqhkpxlfihjbkcsrxbk3gwha42bg";
    url = "https://github.com/BinaryAnalysisPlatform/bap/archive/v1.0.0.tar.gz";
  };
}

