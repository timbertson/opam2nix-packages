world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      cohttp = opamSelection.cohttp;
      core = opamSelection.core;
      cryptokit = opamSelection.cryptokit;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocaml-inifiles = opamSelection.ocaml-inifiles;
      ocamlfind = opamSelection.ocamlfind or null;
      omake = opamSelection.omake;
      ounit = opamSelection.ounit;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      xml-light = opamSelection.xml-light;
      yojson = opamSelection.yojson;
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
  name = "aws-s3-0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "aws-s3";
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
    sha256 = "1ssdvji2zsry4xqhjmr01k8s04rqhdcq5km8nniqq7mziq4azcsp";
    url = "https://github.com/andersfugmann/aws-s3/archive/0.9.0.tar.gz";
  };
}

