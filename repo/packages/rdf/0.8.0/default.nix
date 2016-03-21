world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cryptokit = opamSelection.cryptokit;
      menhir = opamSelection.menhir;
      mysql = opamSelection.mysql or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      pcre = opamSelection.pcre;
      postgresql = opamSelection.postgresql or null;
      ulex = opamSelection.ulex;
      uuidm = opamSelection.uuidm;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "rdf-0.8.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "rdf";
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
    sha256 = "1xd4fmpkxj069z8n415hpqbaaa5kqzm600qmbrgbgj6c4ba0rf9f";
    url = "http://zoggy.github.io/ocaml-rdf/ocaml-rdf-0.8.0.tar.gz";
  };
}

