world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      ctypes = opamSelection.ctypes;
      lwt = opamSelection.lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      osx-cf = opamSelection.osx-cf;
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
  name = "osx-fsevents-0.1.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "osx-fsevents";
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
    sha256 = "0pdjgcszi0apj6f6wzkdyf9zryp34l86sq2cgp90y4l21kjybbqv";
    url = "https://github.com/dsheets/ocaml-osx-fsevents/archive/0.1.2.tar.gz";
  };
}

