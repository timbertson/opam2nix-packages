world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      config-file = opamSelection.config-file;
      lablgtk = opamSelection.lablgtk;
      lablgtk-extras = opamSelection.lablgtk-extras;
      mysql = opamSelection.mysql;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      xml-light = opamSelection.xml-light;
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
  name = "dbforge-2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "dbforge";
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
    sha256 = "0a7hkf4z22gnn1i7n6x3bnm3443h5v95syrd7hhv8mh55nmdm4rl";
    url = "http://zoggy.github.com/dbforge/dbforge-2.0.tar.gz";
  };
}

