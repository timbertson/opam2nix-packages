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
      core_kernel = opamSelection.core_kernel;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "sociaml-tumblr-api-0.2.0";
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
    sha256 = "19q6hvnn3k9r4ml31ankcw4sqbrx87aaldrfqbq9spxbkra85d48";
    url = "https://github.com/dominicjprice/sociaml-tumblr-api/archive/v0.2.0.tar.gz";
  };
}

