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
      ppx_meta_conv = opamSelection.ppx_meta_conv;
      ppx_monadic = opamSelection.ppx_monadic;
      ppx_orakuda = opamSelection.ppx_orakuda;
      spotlib = opamSelection.spotlib;
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
  name = "opamfind-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "opamfind";
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
    sha256 = "1qng2qpi1n5070pjla65zkw69gqxm9ryc13zamlll9hwqqxp0v7m";
    url = "https://bitbucket.org/camlspotter/opamfind/get/1.0.0.tar.gz";
  };
}

