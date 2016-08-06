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
      base-threads = opamSelection.base-threads;
      base-unix = opamSelection.base-unix;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      fmt = opamSelection.fmt;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-flow = opamSelection.mirage-flow;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "hvsock-0.8.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "hvsock";
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
    sha256 = "1wnn1ry2hfxi2fc6jqmjw5r79ik11fyqn7hmjj2j05rny5nzqjx3";
    url = "https://github.com/djs55/ocaml-hvsock/archive/v0.8.1.tar.gz";
  };
}

