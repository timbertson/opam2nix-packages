world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      base-unix = opamSelection.base-unix or null;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp or null;
      crunch = opamSelection.crunch;
      cstruct = opamSelection.cstruct;
      ezjsonm = opamSelection.ezjsonm;
      fmt = opamSelection.fmt;
      git = opamSelection.git or null;
      git-unix = opamSelection.git-unix or null;
      hex = opamSelection.hex;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-git = opamSelection.mirage-git or null;
      mirage-tc = opamSelection.mirage-tc;
      mstruct = opamSelection.mstruct;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlgraph = opamSelection.ocamlgraph;
      re = opamSelection.re;
      stringext = opamSelection.stringext;
      uri = opamSelection.uri;
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
  name = "irmin-0.11.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "irmin";
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
    sha256 = "0cvxw1pkri0dib6dbprqwzqrx2ssx16c9n4ws724mb267q7r9j8v";
    url = "https://github.com/mirage/irmin/archive/0.11.0.tar.gz";
  };
}

