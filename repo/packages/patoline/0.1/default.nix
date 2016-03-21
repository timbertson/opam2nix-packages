world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlimages = opamSelection.camlimages;
      camlzip = opamSelection.camlzip;
      camomile = opamSelection.camomile;
      dypgen = opamSelection.dypgen;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      sqlite3 = opamSelection.sqlite3;
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
  name = "patoline-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "patoline";
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
    sha256 = "02hvm5m739hvdal6jnylm4gsiyw458nb6md6y94rbmy88n0n4s7j";
    url = "http://patoline.org/darcs/patoline/patoline-0.1.tar.gz";
  };
}

