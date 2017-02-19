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
  name = "bap-llvm-1.2.0";
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
    sha256 = "033s16s0igrhqppjarv101483p8fbpwnn0mm64f9gmipc9m5x661";
    url = "https://github.com/BinaryAnalysisPlatform/bap/archive/v1.2.0.tar.gz";
  };
}

