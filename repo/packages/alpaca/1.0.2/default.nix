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
      base64 = opamSelection.base64;
      core = opamSelection.core;
      cryptokit = opamSelection.cryptokit;
      cstruct = opamSelection.cstruct;
      dns = opamSelection.dns;
      io-page = opamSelection.io-page;
      ipaddr = opamSelection.ipaddr;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      sodium = opamSelection.sodium;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "alpaca-1.0.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "alpaca";
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
    sha256 = "0hfxwgp5fhpj17rnkjx9ppklfj4ackik33vw1kgdyb62zkczg2z2";
    url = "https://github.com/marklrh/Alpaca/archive/Alpaca-v1.0.2.tar.gz";
  };
}

