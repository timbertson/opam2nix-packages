world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      expect = opamSelection.expect;
      extlib = opamSelection.extlib;
      fileutils = opamSelection.fileutils;
      ocaml = opamSelection.ocaml;
      ocaml-data-notation = opamSelection.ocaml-data-notation;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlgraph = opamSelection.ocamlgraph;
      ocamlify = opamSelection.ocamlify;
      ounit = opamSelection.ounit;
      pcre = opamSelection.pcre;
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
  name = "oasis-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "oasis";
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
    sha256 = "0i8k8gsdl2fyfgwmgmxcgjc8fxh9xzkp0nsa19jyhi6r59w6fl08";
    url = "https://forge.ocamlcore.org/frs/download.php/501/oasis-0.2.0.tar.gz";
  };
}

