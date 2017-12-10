world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      jbuilder = opamSelection.jbuilder;
      menhir = opamSelection.menhir;
      minisat = opamSelection.minisat;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      odoc = opamSelection.odoc or null;
      ounit = opamSelection.ounit or null;
      qbf = opamSelection.qbf or null;
      re = opamSelection.re;
      yices2 = opamSelection.yices2 or null;
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
  name = "touist-3.5.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "touist";
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
    sha256 = "1i20dps5npg3ncvlmyacscf58qzc0a6161m62n3d6vnjrql496l5";
    url = "https://github.com/touist/touist/archive/v3.5.0.tar.gz";
  };
}

