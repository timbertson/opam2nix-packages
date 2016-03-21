world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.unzip or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      extlib = opamSelection.extlib;
      lablgtk = opamSelection.lablgtk or null;
      lwt = opamSelection.lwt;
      obus = opamSelection.obus or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      ocurl = opamSelection.ocurl;
      ounit = opamSelection.ounit;
      react = opamSelection.react;
      sha = opamSelection.sha;
      xmlm = opamSelection.xmlm;
      yojson = opamSelection.yojson;
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
  name = "0install-2.9.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "0install";
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
    sha256 = "0c8qj25p9r3glihxbpla1c3k06lqbcgwwdsba83jhw9g6yricfyf";
    url = "https://downloads.sf.net/project/zero-install/0install/2.9.1/0install-2.9.1.tar.bz2";
  };
}

