world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      odoc = opamSelection.odoc or null;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
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
  name = "ocaml-logicalform-v0.6.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocaml-logicalform";
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
    sha256 = "1vpcdxrhx4hgjgmm9570k7036aaf3v96m0vhxf2ah01jrpazxchp";
    url = "https://github.com/SaswatPadhi/ocaml-logicalform/archive/v0.6.0.tar.gz";
  };
}

