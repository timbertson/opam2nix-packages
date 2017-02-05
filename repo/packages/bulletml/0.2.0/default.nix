world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest;
      base64 = opamSelection.base64;
      js_of_ocaml = opamSelection.js_of_ocaml;
      mparser = opamSelection.mparser;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlsdl = opamSelection.ocamlsdl;
      ounit = opamSelection.ounit;
      ppx_deriving = opamSelection.ppx_deriving;
      re = opamSelection.re;
      xml-light = opamSelection.xml-light;
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
  name = "bulletml-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "bulletml";
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
    sha256 = "069s26j87h6yxyplizl6cs56dmvilmd0db04p23zi0v9n0wh8mzm";
    url = "https://github.com/emillon/bulletml/archive/v0.2.0.tar.gz";
  };
}

