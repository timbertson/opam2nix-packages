world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlp4 = opamSelection.camlp4;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      io-page-unix = opamSelection.io-page-unix;
      lwt = opamSelection.lwt;
      mirage-block-unix = opamSelection.mirage-block-unix;
      mirage-types = opamSelection.mirage-types;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
      sexplib = opamSelection.sexplib;
      type_conv = opamSelection.type_conv;
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
  name = "shared-block-ring-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "shared-block-ring";
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
    sha256 = "1xa0qzil3f8m0db9c58fy77hhpm7dlw3gdf6kiihm9kbbk4i75p0";
    url = "https://github.com/mirage/shared-block-ring/archive/v1.0.0.tar.gz";
  };
}

