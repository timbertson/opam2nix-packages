world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      duration = opamSelection.duration;
      fmt = opamSelection.fmt;
      jbuilder = opamSelection.jbuilder;
      mirage-device = opamSelection.mirage-device;
      mirage-flow = opamSelection.mirage-flow;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "mirage-protocols-1.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-protocols";
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
    sha256 = "17jfqalg1n1s87xbj3ximm8b7nn4x6dvk1lpryzlip5yrsh9zsp9";
    url = "https://github.com/mirage/mirage-protocols/releases/download/v1.3.0/mirage-protocols-1.3.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

