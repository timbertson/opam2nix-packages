world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      git-unix = opamSelection.git-unix;
      irmin = opamSelection.irmin;
      irmin-fs = opamSelection.irmin-fs;
      irmin-git = opamSelection.irmin-git;
      irmin-http = opamSelection.irmin-http;
      irmin-mem = opamSelection.irmin-mem;
      irmin-watcher = opamSelection.irmin-watcher;
      jbuilder = opamSelection.jbuilder;
      mtime = opamSelection.mtime or null;
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
  name = "irmin-unix-1.3.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "irmin-unix";
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
    sha256 = "18srcd29dyjxdwwpfd24fdmn8sk3ndqz17ppvmgpqwjw0fpfajbp";
    url = "https://github.com/mirage/irmin/releases/download/1.3.3/irmin-1.3.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

