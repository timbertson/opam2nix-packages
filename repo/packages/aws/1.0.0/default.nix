world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      async_ssl = opamSelection.async_ssl or null;
      base-threads = opamSelection.base-threads or null;
      base-unix = opamSelection.base-unix or null;
      calendar = opamSelection.calendar;
      cohttp = opamSelection.cohttp or null;
      ezxmlm = opamSelection.ezxmlm;
      lwt = opamSelection.lwt or null;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ssl = opamSelection.ssl or null;
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
  name = "aws-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "aws";
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
    sha256 = "1s380xgywiidawci0vbhq8kbzjk5my4wzq7xlz01xyg64smq2fgc";
    url = "https://github.com/inhabitedtype/ocaml-aws/releases/download/aws-v1.0.0/aws-v1.0.0.tar.gz";
  };
}

