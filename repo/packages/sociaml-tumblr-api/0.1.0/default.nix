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
      core = opamSelection.core;
      csv = opamSelection.csv;
      lwt = opamSelection.lwt;
      meta_conv = opamSelection.meta_conv;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      sociaml-oauth-client = opamSelection.sociaml-oauth-client;
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
  name = "sociaml-tumblr-api-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sociaml-tumblr-api";
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
    sha256 = "0q0fkdkazjgi51qapa8dwiqby75595c1lkzfniz721ay4fazjdbx";
    url = "https://github.com/dominicjprice/sociaml-tumblr-api/archive/v0.1.0.tar.gz";
  };
}

