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
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      wcs-api = opamSelection.wcs-api;
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
  name = "wcs-2017-05-26.04";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "wcs";
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
    sha256 = "0zi04dqa41kjqw0wyzy18vyk2ig2gk0x8dyvq1fxs37fc3y5zn4y";
    url = "https://github.com/IBM/wcs-ocaml/archive/2017-05-26.04.tar.gz";
  };
}

