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
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
      ppx_type_conv = opamSelection.ppx_type_conv;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
      sha = opamSelection.sha;
      topkg = opamSelection.topkg;
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
  name = "qcow-0.9.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "qcow";
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
    sha256 = "1g4v7r9rbjz0nsq5rd9pq9w02pnmf3hxn7gnvajwc0j4jfz4i012";
    url = "https://github.com/mirage/ocaml-qcow/releases/download/0.9.4/qcow-0.9.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

