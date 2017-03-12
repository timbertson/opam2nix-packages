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
      atdgen = opamSelection.atdgen or null;
      base-bytes = opamSelection.base-bytes;
      base-unix = opamSelection.base-unix;
      cohttp = opamSelection.cohttp or null;
      containers = opamSelection.containers;
      irc-client = opamSelection.irc-client;
      lambdasoup = opamSelection.lambdasoup or null;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      result = opamSelection.result;
      sequence = opamSelection.sequence or null;
      stringext = opamSelection.stringext;
      tls = opamSelection.tls;
      uri = opamSelection.uri or null;
      yojson = opamSelection.yojson;
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
  name = "calculon-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "calculon";
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
    sha256 = "17b3i00x5f1jdirpgmn376d0vypqs3hkyny4hc6pswcpcwr0vczf";
    url = "http://github.com/c-cube/calculon/archive/0.1.tar.gz";
  };
}

