world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      containers = opamSelection.containers;
      fmt = opamSelection.fmt;
      gen = opamSelection.gen;
      hashcons = opamSelection.hashcons;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      menhir = opamSelection.menhir;
      mtime = opamSelection.mtime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_blob = opamSelection.ppx_blob;
      ppx_deriving = opamSelection.ppx_deriving;
      ppxfind = opamSelection.ppxfind;
      printbox = opamSelection.printbox;
      sequence = opamSelection.sequence;
      visitors = opamSelection.visitors;
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
  name = "electrod-0.1.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "electrod";
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
    sha256 = "0ajky5pridihab88rz3byh6b3qbjl29nqbb3zyw57s4fp3ifjjl9";
    url = "https://github.com/grayswandyr/electrod/releases/download/0.1.4/electrod-0.1.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

