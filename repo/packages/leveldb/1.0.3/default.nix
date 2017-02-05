world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libsnappy-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-leveldb = opamSelection.conf-leveldb;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      omake = opamSelection.omake;
      ounit = opamSelection.ounit;
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
  name = "leveldb-1.0.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "leveldb";
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
    sha256 = "1rin371fgmlq7r36k7y2n048saf0hj0qifx0ypj1p9j7iw2rwd7x";
    url = "https://github.com/mfp/ocaml-leveldb/archive/ocaml-leveldb-1.0.3.tar.gz";
  };
}

