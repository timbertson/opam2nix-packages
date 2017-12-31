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
      dockerfile = opamSelection.dockerfile;
      fmt = opamSelection.fmt;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocaml-version = opamSelection.ocaml-version;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "dockerfile-opam-4.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "dockerfile-opam";
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
    sha256 = "00q2qxi3hrn02vc47z03l9chv6a1g4qqhj25zfxs19anbhg65g8z";
    url = "https://github.com/avsm/ocaml-dockerfile/releases/download/v4.0.0/dockerfile-4.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

