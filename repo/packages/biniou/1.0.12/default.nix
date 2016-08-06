world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-which = opamSelection.conf-which;
      easy-format = opamSelection.easy-format;
      ocaml = opamSelection.ocaml;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "biniou-1.0.12";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "biniou";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "11n6ksq0l5014vqyb3w0vws947lpgbjdj084pfalnljdv4hffimr";
    url = "https://github.com/mjambon/biniou/archive/v1.0.12.tar.gz";
  };
}

