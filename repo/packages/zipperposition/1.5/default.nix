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
      jbuilder = opamSelection.jbuilder;
      menhir = opamSelection.menhir;
      msat = opamSelection.msat;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      sequence = opamSelection.sequence;
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
  name = "zipperposition-1.5";
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
    sha256 = "0lmr9bfckbzc6mjk7arrqik0z9nx9pqss4mv9v6ab6jlnw672nxq";
    url = "https://github.com/c-cube/zipperposition/archive/1.5.tar.gz";
  };
}

