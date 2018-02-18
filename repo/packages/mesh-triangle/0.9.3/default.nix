world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      base-bigarray = opamSelection.base-bigarray;
      base-bytes = opamSelection.base-bytes;
      configurator = opamSelection.configurator;
      jbuilder = opamSelection.jbuilder;
      lacaml = opamSelection.lacaml or null;
      mesh = opamSelection.mesh;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      stdio = opamSelection.stdio;
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
  name = "mesh-triangle-0.9.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mesh-triangle";
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
    sha256 = "08517f7qp8pryqh704ah5szwq5iwcjjriyzfj2fhzw0mm6q5danx";
    url = "https://github.com/Chris00/mesh/releases/download/0.9.3/mesh-0.9.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

