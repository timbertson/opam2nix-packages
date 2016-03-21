world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      atdgen = opamSelection.atdgen;
      base-threads = opamSelection.base-threads;
      core = opamSelection.core;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re2 = opamSelection.re2;
      textutils = opamSelection.textutils;
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
  name = "oclaunch-0.3.0-pre1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "oclaunch";
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
    sha256 = "0dkkwc53b3xin3xbjs0w6bvrbg84m6xxnd65yfqgj7m29jz4qdcd";
    url = "http://download.tuxfamily.org/oclaunch/v03/oclaunch_v0.3.0-pre1_src.tar.gz";
  };
}

