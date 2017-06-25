world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bisect_ppx = opamSelection.bisect_ppx;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      io-page-unix = opamSelection.io-page-unix;
      lwt = opamSelection.lwt;
      mirage-block-unix = opamSelection.mirage-block-unix;
      mirage-clock-unix = opamSelection.mirage-clock-unix;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
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
  name = "shared-block-ring-2.3.0";
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
    sha256 = "0lcy2yzdsimr4ki5nlkdg5p2z7iq0il00whrxss4h6mndha5m3zs";
    url = "https://github.com/mirage/shared-block-ring/archive/v2.3.0.tar.gz";
  };
}

