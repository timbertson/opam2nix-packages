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
      cstruct = opamSelection.cstruct;
      lwt = opamSelection.lwt;
      mirage-block = opamSelection.mirage-block;
      mirage-block-unix = opamSelection.mirage-block-unix;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
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
  name = "qcow-format-0.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "qcow-format";
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
    sha256 = "1svvnhbalsnmgdjwkmfbnzqxrm0ym936k056f0hcvdx86cr70kmx";
    url = "https://github.com/mirage/ocaml-qcow/archive/v0.2.tar.gz";
  };
}

