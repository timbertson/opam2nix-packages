world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.clang or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bap-std = opamSelection.bap-std;
      cmdliner = opamSelection.cmdliner;
      conf-bap-llvm = opamSelection.conf-bap-llvm or null;
      conf-env-travis = opamSelection.conf-env-travis;
      conf-llvm = opamSelection.conf-llvm or null;
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
  name = "bap-llvm-1.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "bap-llvm";
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
    sha256 = "1ms95m4j1qrmy7zqmsn2izh7gq68lnmssl7chyhk977kd3sxj66m";
    url = "https://github.com/BinaryAnalysisPlatform/bap/archive/v1.1.0.tar.gz";
  };
}

