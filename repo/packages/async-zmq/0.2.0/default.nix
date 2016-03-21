world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      core = opamSelection.core;
      obuild = opamSelection.obuild;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      sexplib = opamSelection.sexplib;
      zmq = opamSelection.zmq;
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
  name = "async-zmq-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "async-zmq";
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
    sha256 = "1lriz6bw5gqrcz1yp2kslf57i8g3rzmd4q8p9mmm96cjd66hshaj";
    url = "https://github.com/rgrinberg/async-zmq/archive/v0.2.0.tar.gz";
  };
}

