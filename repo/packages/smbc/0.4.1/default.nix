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
      containers = opamSelection.containers;
      menhir = opamSelection.menhir;
      msat = opamSelection.msat;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      sequence = opamSelection.sequence;
      tip-parser = opamSelection.tip-parser;
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
  name = "smbc-0.4.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "smbc";
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
    sha256 = "10gaz7fv7ajzw044mw7fa0ji4wblhiwbg7w70md9pr3p8ij9j11l";
    url = "https://github.com/c-cube/smbc/archive/0.4.1.tar.gz";
  };
}

