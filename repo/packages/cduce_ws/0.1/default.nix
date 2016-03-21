world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cduce = opamSelection.cduce;
      ocaml = opamSelection.ocaml;
      ocaml-src = opamSelection.ocaml-src;
      ocamlfind = opamSelection.ocamlfind or null;
      ocurl = opamSelection.ocurl;
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
  name = "cduce_ws-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cduce_ws";
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
    sha256 = "1x5yvq3bq0vsq8rvfx299w57k56adcpd58ijn977dbfv1xngsjbz";
    url = "http://www.cduce.org/download/cduce_ws-0.1.tar.gz";
  };
}

