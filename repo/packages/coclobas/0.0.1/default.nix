world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      ketrew = opamSelection.ketrew or null;
      lwt = opamSelection.lwt;
      nonstd = opamSelection.nonstd;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      odate = opamSelection.odate;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      pvem_lwt_unix = opamSelection.pvem_lwt_unix;
      solvuu-build = opamSelection.solvuu-build;
      sosa = opamSelection.sosa;
      trakeva = opamSelection.trakeva;
      uuidm = opamSelection.uuidm;
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
  name = "coclobas-0.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "coclobas";
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
    sha256 = "0h2jzc8gyw4kz4bjw05acpgs7x1zq0x0mlcb0hzqvp58hayhahr6";
    url = "http://github.com/hammerlab/coclobas/archive/coclobas.0.0.1.tar.gz";
  };
}

