world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bap-abi = opamSelection.bap-abi;
      bap-api = opamSelection.bap-api;
      bap-arm = opamSelection.bap-arm;
      bap-byteweight = opamSelection.bap-byteweight;
      bap-c = opamSelection.bap-c;
      bap-cache = opamSelection.bap-cache;
      bap-callsites = opamSelection.bap-callsites;
      bap-demangle = opamSelection.bap-demangle;
      bap-dump-symbols = opamSelection.bap-dump-symbols;
      bap-frontc = opamSelection.bap-frontc;
      bap-frontend = opamSelection.bap-frontend;
      bap-llvm = opamSelection.bap-llvm;
      bap-mc = opamSelection.bap-mc;
      bap-microx = opamSelection.bap-microx;
      bap-objdump = opamSelection.bap-objdump;
      bap-print = opamSelection.bap-print;
      bap-std = opamSelection.bap-std;
      bap-symbol-reader = opamSelection.bap-symbol-reader;
      bap-taint = opamSelection.bap-taint;
      bap-taint-propagator = opamSelection.bap-taint-propagator;
      bap-term-mapper = opamSelection.bap-term-mapper;
      bap-trace = opamSelection.bap-trace;
      bap-traces = opamSelection.bap-traces;
      bap-warn-unused = opamSelection.bap-warn-unused;
      bap-x86 = opamSelection.bap-x86;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "bap-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "bap";
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

