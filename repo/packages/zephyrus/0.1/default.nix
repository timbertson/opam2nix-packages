world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      atd = opamSelection.atd;
      atdgen = opamSelection.atdgen;
      extlib = opamSelection.extlib or null;
      extlib-compat = opamSelection.extlib-compat or null;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
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
  name = "zephyrus-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "zephyrus";
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
    sha256 = "0y7wllnj6jgb5i71yh30xr3x9mfypqj7wxzfzmh5ic86lvxa6759";
    url = "http://archives.pps.univ-paris-diderot.fr/~qba/archives/2013.08.30/zephyrus-0.1.tar.gz";
  };
}

