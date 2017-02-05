world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ANSITerminal = opamSelection.ANSITerminal;
      base-unix = opamSelection.base-unix;
      cohttp = opamSelection.cohttp;
      ezxmlm = opamSelection.ezxmlm;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      stringext = opamSelection.stringext;
      tyxml = opamSelection.tyxml;
      yojson = opamSelection.yojson;
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
  name = "podge-0.7.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "podge";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "128g91z75m94crwbg4mlvq8d1277p06lds3szdl1wrwq6qflgj7j";
    url = "https://github.com/fxfactorial/podge/archive/v0.7.0.tar.gz";
  };
}

