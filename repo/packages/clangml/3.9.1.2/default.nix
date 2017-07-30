world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.boost or null) (pkgs.boost160 or null)
        (pkgs."clang-3.9" or null) (pkgs."dev-libs/boost" or null)
        (pkgs.libboost-dev or null) (pkgs."libclang-3.9-dev" or null)
        (pkgs."llvm-3.9-dev" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ANSITerminal = opamSelection.ANSITerminal;
      base-unix = opamSelection.base-unix;
      batteries = opamSelection.batteries;
      camlp4 = opamSelection.camlp4;
      conf-binutils = opamSelection.conf-binutils;
      conf-ncurses = opamSelection.conf-ncurses;
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
  name = "clangml-3.9.1.2";
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
    sha256 = "1xxvma132c9b7lmvvsi58icqya8zhhhzawxqg5n2sy3f4lj3lbg1";
    url = "https://github.com/Antique-team/clangml/archive/v3.9.1.2.tar.gz";
  };
}

