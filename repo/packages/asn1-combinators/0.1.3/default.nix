world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      result = opamSelection.result;
      topkg = opamSelection.topkg;
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
  name = "asn1-combinators-0.1.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "asn1-combinators";
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
    sha256 = "04z0wgh40n1jihs7avnclpigxz0k5hdql6x3z9rrfmlprdgqh54j";
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v0.1.3/asn1-combinators-0.1.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

