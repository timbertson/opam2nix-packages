world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      cmdliner = opamSelection.cmdliner;
      fmt = opamSelection.fmt;
      io-page = opamSelection.io-page;
      jbuilder = opamSelection.jbuilder;
      lambda-term = opamSelection.lambda-term;
      logs = opamSelection.logs;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      protocol-9p = opamSelection.protocol-9p;
      protocol-9p-unix = opamSelection.protocol-9p-unix;
      rresult = opamSelection.rresult;
      win-error = opamSelection.win-error;
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
  name = "protocol-9p-tool-0.11.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "protocol-9p-tool";
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
    sha256 = "1bqxriyd17xycwki0gdamzl2gsjl663ds6p3vmwn971pf607ph3m";
    url = "https://github.com/mirage/ocaml-9p/releases/download/v0.11.2/protocol-9p-0.11.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

