world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      base-bytes = opamSelection.base-bytes;
      bdd = opamSelection.bdd;
      gg = opamSelection.gg;
      hardcaml = opamSelection.hardcaml;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      sattools = opamSelection.sattools;
      topkg = opamSelection.topkg;
      uchar = opamSelection.uchar;
      uutf = opamSelection.uutf;
      vg = opamSelection.vg;
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
  name = "hardcaml-bloop-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "hardcaml-bloop";
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
    sha256 = "0jqgpz3j98mv5042ccnc9a5365w2k4zqcsg3fgakvfcib1snf1ap";
    url = "https://github.com/ujamjar/hardcaml-bloop/archive/v0.1.0.tar.gz";
  };
}

