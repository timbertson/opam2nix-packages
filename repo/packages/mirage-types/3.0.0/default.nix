world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
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
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "mirage-types-3.0.0";
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
    sha256 = "05fmyin87w74sg33pbvy7wzbcdr8pqrhl29xjv1g0khmizv4hqsw";
    url = "http://github.com/mirage/mirage/archive/v3.0.0.tar.gz";
  };
}

