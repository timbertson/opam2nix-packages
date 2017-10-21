world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.clang or null) (pkgs.curl or null) (pkgs.gmp or null)
        (pkgs.graphviz or null) (pkgs.libcurl4-gnutls-dev or null)
        (pkgs.libgmp-dev or null) (pkgs.libzip or null)
        (pkgs.libzip-dev or null) (pkgs.llvm or null)
        (pkgs."llvm-3.4" or null) (pkgs."llvm-3.4-dev" or null)
        (pkgs.m4 or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-unix = opamSelection.base-unix;
      bitstring = opamSelection.bitstring;
      camlzip = opamSelection.camlzip;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      conf-time = opamSelection.conf-time;
      core_kernel = opamSelection.core_kernel;
      ezjsonm = opamSelection.ezjsonm;
      faillib = opamSelection.faillib;
      fileutils = opamSelection.fileutils;
      lwt = opamSelection.lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlgraph = opamSelection.ocamlgraph;
      ocurl = opamSelection.ocurl;
      piqi = opamSelection.piqi;
      re = opamSelection.re;
      uri = opamSelection.uri;
      utop = opamSelection.utop;
      uuidm = opamSelection.uuidm;
      zarith = opamSelection.zarith;
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
  name = "bap-0.9.9";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "bap";
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
    sha256 = "04riqscz4fm9vi8a50vx1a674c6956ygfipyscdn97adg3bndcgk";
    url = "https://github.com/BinaryAnalysisPlatform/bap/archive/v0.9.9.tar.gz";
  };
}

