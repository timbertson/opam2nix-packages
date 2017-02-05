world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      hardcaml = opamSelection.hardcaml;
      hardcaml-examples = opamSelection.hardcaml-examples;
      hardcaml-waveterm = opamSelection.hardcaml-waveterm;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      reedsolomon = opamSelection.reedsolomon;
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
  name = "hardcaml-reedsolomon-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "hardcaml-reedsolomon";
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
    sha256 = "05d296ny3pxjdjr3pi0lj42bcxi1n8x64rwm9ixcnb4kpd5w9p2a";
    url = "https://github.com/ujamjar/hardcaml-reedsolomon/archive/v0.3.0.tar.gz";
  };
}

