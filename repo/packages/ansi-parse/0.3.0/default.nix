world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      angstrom = opamSelection.angstrom;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving = opamSelection.ppx_deriving;
      topkg = opamSelection.topkg;
      tyxml = opamSelection.tyxml;
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
  name = "ansi-parse-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ansi-parse";
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
    sha256 = "154pnjj7z5lvgmfczyfajl5al4dghwr6pazp706krfwpwpssi8xj";
    url = "https://github.com/jdjakub/ansi-parse/releases/download/v0.3.0/ansi-parse-0.3.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

