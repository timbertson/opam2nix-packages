world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      archimedes = opamSelection.archimedes or null;
      base-threads = opamSelection.base-threads;
      base-unix = opamSelection.base-unix;
      base64 = opamSelection.base64;
      cairo2 = opamSelection.cairo2 or null;
      cppo = opamSelection.cppo;
      cppo_ocamlbuild = opamSelection.cppo_ocamlbuild;
      lwt = opamSelection.lwt;
      lwt-zmq = opamSelection.lwt-zmq;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
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
  name = "jupyter-0.0.0";
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
    sha256 = "0c3k7k6j79ycdszdpbxw6c4nb9k8s84xhsn6b9kh11xh9rlirr1a";
    url = "https://github.com/akabe/ocaml-jupyter/archive/v0.0.0.tar.gz";
  };
}

