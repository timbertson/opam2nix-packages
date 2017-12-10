world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-threads = opamSelection.base-threads;
      base-unix = opamSelection.base-unix;
      base64 = opamSelection.base64;
      cryptokit = opamSelection.cryptokit;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      lwt-zmq = opamSelection.lwt-zmq;
      merlin = opamSelection.merlin or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      stdint = opamSelection.stdint;
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
  name = "jupyter-2.2.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "jupyter";
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
    sha256 = "17sf8xcznd6hg4bw7appwjazm0gxd0zz9fgiqlqllklqsb9pggwf";
    url = "https://github.com/akabe/ocaml-jupyter/releases/download/v2.2.1/jupyter-2.2.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

