world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.coreutils or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      fileutils = opamSelection.fileutils;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pprint = opamSelection.pprint;
      stdint = opamSelection.stdint;
      yojson = opamSelection.yojson;
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
  name = "fstar-0.9.4.0-beta0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "fstar";
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
    sha256 = "04m2nqfmd7czhkmswmp8hqz8hwqs743bh6s6k1iw61p7x3cm6xlz";
    url = "https://github.com/FStarLang/FStar/archive/schoolNancy17.tar.gz";
  };
}

