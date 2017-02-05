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
      cohttp = opamSelection.cohttp or null;
      crunch = opamSelection.crunch;
      cstruct = opamSelection.cstruct;
      ezjsonm = opamSelection.ezjsonm;
      fmt = opamSelection.fmt;
      git = opamSelection.git or null;
      git-unix = opamSelection.git-unix or null;
      hex = opamSelection.hex;
      irmin-watcher = opamSelection.irmin-watcher or null;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-git = opamSelection.mirage-git or null;
      mirage-tc = opamSelection.mirage-tc;
      mstruct = opamSelection.mstruct;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlgraph = opamSelection.ocamlgraph;
      re = opamSelection.re;
      topkg = opamSelection.topkg;
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
  name = "irmin-0.12.0";
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
    sha256 = "0psk1f8h622fpycax09yls85smsiqnbanvbwbcxa2h8w769zarfj";
    url = "https://github.com/mirage/irmin/releases/download/0.12.0/irmin-0.12.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

