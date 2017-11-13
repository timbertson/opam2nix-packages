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
      bap-beagle = opamSelection.bap-beagle;
      bap-byteweight = opamSelection.bap-byteweight;
      bap-c = opamSelection.bap-c;
      bap-cache = opamSelection.bap-cache;
      bap-callsites = opamSelection.bap-callsites;
      bap-cxxfilt = opamSelection.bap-cxxfilt;
      bap-dead-code-elimination = opamSelection.bap-dead-code-elimination;
      bap-demangle = opamSelection.bap-demangle;
      bap-dump-symbols = opamSelection.bap-dump-symbols;
      bap-frontc = opamSelection.bap-frontc;
      bap-frontend = opamSelection.bap-frontend;
      bap-llvm = opamSelection.bap-llvm;
      bap-mc = opamSelection.bap-mc;
      bap-microx = opamSelection.bap-microx;
      bap-objdump = opamSelection.bap-objdump;
      bap-primus = opamSelection.bap-primus;
      bap-primus-lisp = opamSelection.bap-primus-lisp;
      bap-primus-support = opamSelection.bap-primus-support;
      bap-primus-x86 = opamSelection.bap-primus-x86;
      bap-print = opamSelection.bap-print;
      bap-relocatable = opamSelection.bap-relocatable;
      bap-run = opamSelection.bap-run;
      bap-ssa = opamSelection.bap-ssa;
      bap-std = opamSelection.bap-std;
      bap-strings = opamSelection.bap-strings;
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
  name = "bap-1.3.0";
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
    sha256 = "0v95v9mp7mg8fj25ry0w7566zd9xp6cs8nnqj4l38q54fb1hfav9";
    url = "https://github.com/BinaryAnalysisPlatform/bap/archive/v1.3.0.tar.gz";
  };
}

