world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      jbuilder = opamSelection.jbuilder;
      mirage-block = opamSelection.mirage-block;
      mirage-channel = opamSelection.mirage-channel;
      mirage-clock = opamSelection.mirage-clock;
      mirage-console = opamSelection.mirage-console;
      mirage-device = opamSelection.mirage-device;
      mirage-flow = opamSelection.mirage-flow;
      mirage-fs = opamSelection.mirage-fs;
      mirage-kv = opamSelection.mirage-kv;
      mirage-net = opamSelection.mirage-net;
      mirage-protocols = opamSelection.mirage-protocols;
      mirage-random = opamSelection.mirage-random;
      mirage-stack = opamSelection.mirage-stack;
      mirage-time = opamSelection.mirage-time;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "mirage-types-3.0.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-types";
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
    sha256 = "1hkg6q7ad0ipaqzfr822amqz7cqqwvnih34ywybcy6jn92r7yd5p";
    url = "https://github.com/mirage/mirage/releases/download/3.0.5/mirage-3.0.5.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

