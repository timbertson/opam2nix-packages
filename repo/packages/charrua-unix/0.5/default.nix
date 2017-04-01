world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      charrua-core = opamSelection.charrua-core;
      cmdliner = opamSelection.cmdliner;
      lwt = opamSelection.lwt;
      mtime = opamSelection.mtime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      rawlink = opamSelection.rawlink;
      tuntap = opamSelection.tuntap;
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
  name = "charrua-unix-0.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "charrua-unix";
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
    sha256 = "0276hjkj38n0wbw41ssl3ng522agw7yn12w3gifq5qvz5d22d5ii";
    url = "https://github.com/haesbaert/charrua-unix/archive/v0.5.tar.gz";
  };
}

