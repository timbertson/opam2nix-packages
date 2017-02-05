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
      core_kernel = opamSelection.core_kernel;
      csv = opamSelection.csv;
      lwt = opamSelection.lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_meta_conv = opamSelection.ppx_meta_conv;
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
  name = "sociaml-facebook-api-0.4.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sociaml-facebook-api";
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
    sha256 = "07hxjhjky0j4s19y3lg0scx0w9l8cs6qrqcdrcl8yq27c5ww2znx";
    url = "https://github.com/dominicjprice/sociaml-facebook-api/archive/v0.4.1.tar.gz";
  };
}

