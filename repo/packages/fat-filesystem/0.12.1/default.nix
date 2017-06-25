world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      io-page-unix = opamSelection.io-page-unix;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-block-lwt = opamSelection.mirage-block-lwt;
      mirage-block-unix = opamSelection.mirage-block-unix;
      mirage-fs = opamSelection.mirage-fs;
      mirage-fs-lwt = opamSelection.mirage-fs-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_tools = opamSelection.ppx_tools;
      re = opamSelection.re;
      result = opamSelection.result;
      rresult = opamSelection.rresult;
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
  name = "fat-filesystem-0.12.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "fat-filesystem";
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
    sha256 = "0kq5qgamilk9hq2p7pkzj01ypfsmkclicl9xnr03pgbzv810s21q";
    url = "https://github.com/mirage/ocaml-fat/releases/download/0.12.1/fat-filesystem-0.12.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

