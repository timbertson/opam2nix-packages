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
      base-unix = opamSelection.base-unix;
      containers = opamSelection.containers;
      menhir = opamSelection.menhir;
      msat = opamSelection.msat;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      sequence = opamSelection.sequence;
      tip-parser = opamSelection.tip-parser;
      zarith = opamSelection.zarith;
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
  name = "zipperposition-1.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "zipperposition";
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
    sha256 = "1422gp0q36zsg5ypc1dxk6x5zi0m4jx4z9d35xsa26ggd6gh31nb";
    url = "https://github.com/c-cube/zipperposition/archive/1.2.tar.gz";
  };
}

