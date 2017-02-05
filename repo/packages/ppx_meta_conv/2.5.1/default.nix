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
      ocamlfind = opamSelection.ocamlfind;
      omake = opamSelection.omake;
      ppx_deriving = opamSelection.ppx_deriving;
      ppxx = opamSelection.ppxx;
      sexplib = opamSelection.sexplib or null;
      spotlib = opamSelection.spotlib;
      tiny_json = opamSelection.tiny_json or null;
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
  name = "ppx_meta_conv-2.5.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_meta_conv";
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
    sha256 = "0zfpqyqhdy72dhx4kgqccyqj9anlq3px9i6rliz191dq2d3g6jkk";
    url = "https://bitbucket.org/camlspotter/ppx_meta_conv/get/2.5.1.tar.gz";
  };
}

