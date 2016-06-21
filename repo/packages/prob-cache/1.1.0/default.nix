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
      containers = opamSelection.containers;
      core = opamSelection.core;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      oml = opamSelection.oml;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_protobuf = opamSelection.ppx_deriving_protobuf;
      riakc_ppx = opamSelection.riakc_ppx;
      sequence = opamSelection.sequence;
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
  name = "prob-cache-1.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "prob-cache";
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
    sha256 = "16sg4gqfj7a03bn9rc9yavi6qihwxmw5r8p77jbnpbsi73dwjjji";
    url = "https://github.com/struktured/ocaml-prob-cache/archive/1.1.0.zip";
  };
}

