world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.binutils or null) (pkgs.binutils-dev or null)
        (pkgs.boost or null) (pkgs.boost160 or null)
        (pkgs."clang-3.9" or null) (pkgs."dev-libs/boost" or null)
        (pkgs.libboost-dev or null) (pkgs."libclang-3.9-dev" or null)
        (pkgs.libncurses-dev or null) (pkgs."llvm-3.9-dev" or null)
        (pkgs."sys-devel/binutils" or null)
        (pkgs."sys-devel/binutils-libs" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ANSITerminal = opamSelection.ANSITerminal;
      base-unix = opamSelection.base-unix;
      batteries = opamSelection.batteries;
      camlp4 = opamSelection.camlp4;
      conf-wget = opamSelection.conf-wget;
      deriving = opamSelection.deriving;
      dolog = opamSelection.dolog;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "clangml-3.9.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "clangml";
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
    sha256 = "00j97w85z62n48w6d9sp6kmmssx69259l29wh32cvzv2raa2yibs";
    url = "https://github.com/Antique-team/clangml/archive/v3.9.1.tar.gz";
  };
}

