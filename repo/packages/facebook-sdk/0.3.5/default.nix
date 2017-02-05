world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      calendar = opamSelection.calendar;
      cohttp = opamSelection.cohttp;
      core = opamSelection.core;
      csv = opamSelection.csv;
      lwt = opamSelection.lwt;
      meta_conv = opamSelection.meta_conv;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      ssl = opamSelection.ssl;
      tiny_json = opamSelection.tiny_json;
      tiny_json_conv = opamSelection.tiny_json_conv;
      uri = opamSelection.uri;
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
  name = "facebook-sdk-0.3.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "facebook-sdk";
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
    sha256 = "0hmrrzncvylvppv6nvbvqkdsmq2rigkr2jpg7hb3fipzl7z26z02";
    url = "https://github.com/dominicjprice/facebook-sdk/archive/v0.3.5.tar.gz";
  };
}

