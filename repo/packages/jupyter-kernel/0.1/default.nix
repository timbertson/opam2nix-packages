world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ISO8601 = opamSelection.ISO8601;
      atdgen = opamSelection.atdgen;
      base-bytes = opamSelection.base-bytes;
      base-unix = opamSelection.base-unix;
      hex = opamSelection.hex;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      lwt-zmq = opamSelection.lwt-zmq;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      result = opamSelection.result;
      uuidm = opamSelection.uuidm;
      yojson = opamSelection.yojson;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "jupyter-kernel-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "jupyter-kernel";
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
    sha256 = "0gfryzrh0hxbf775b2a7yxsm2fcinkma6qvsn5wxybvg70gm68am";
    url = "https://github.com/ocaml-jupyter/jupyter-kernel/archive/0.1.tar.gz";
  };
}

