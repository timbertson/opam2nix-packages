world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      opam-core = opamSelection.opam-core;
      opam-format = opamSelection.opam-format;
      opam-repository = opamSelection.opam-repository;
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
  name = "opam-state-2.0.0+x7ebeta";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "opam-state";
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
    sha256 = "02p7rm1vy9wvx82pkzdrl60k9k2y21jwwqhh2n07ns48mdp8myy2";
    url = "https://github.com/ocaml/opam/archive/2.0.0-beta2.tar.gz";
  };
}

