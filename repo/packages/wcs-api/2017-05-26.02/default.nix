world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp-lwt-unix = opamSelection.cohttp-lwt-unix;
      lwt_ssl = opamSelection.lwt_ssl or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      tls = opamSelection.tls or null;
      wcs-lib = opamSelection.wcs-lib;
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
  name = "wcs-api-2017-05-26.02";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "wcs-api";
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
    sha256 = "10s8blsijmc63c12352pccwzcqga07nsgiyfl577q5zwd68ryr86";
    url = "https://github.com/IBM/wcs-ocaml/archive/2017-05-26.02.tar.gz";
  };
}

