world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      fmt = opamSelection.fmt;
      io-page = opamSelection.io-page;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-block = opamSelection.mirage-block;
      mirage-block-lwt = opamSelection.mirage-block-lwt;
      mirage-block-unix = opamSelection.mirage-block-unix;
      mirage-time = opamSelection.mirage-time;
      mirage-time-lwt = opamSelection.mirage-time-lwt;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      qcow = opamSelection.qcow;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
      sha = opamSelection.sha;
      unix-type-representations = opamSelection.unix-type-representations;
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
  name = "qcow-tool-0.10.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "qcow-tool";
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
    sha256 = "0d2hif692b2wmqszc86gs75943ivvnixg1jq8gjkrlccbd2mfnig";
    url = "https://github.com/mirage/ocaml-qcow/releases/download/0.10.2/qcow-0.10.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

