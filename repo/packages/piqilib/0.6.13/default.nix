world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      base64 = opamSelection.base64;
      easy-format = opamSelection.easy-format;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      optcomp = opamSelection.optcomp;
      ulex = opamSelection.ulex;
      xmlm = opamSelection.xmlm;
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
  name = "piqilib-0.6.13";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "piqilib";
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
    sha256 = "1whqr2bb3gds2zmrzqnv8vqka9928w4lx6mi6g244kmbwb2h8d8l";
    url = "https://github.com/alavrik/piqi/archive/v0.6.13.tar.gz";
  };
}

