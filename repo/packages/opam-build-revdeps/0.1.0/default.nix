world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-unix = opamSelection.base-unix;
      calendar = opamSelection.calendar;
      cmdliner = opamSelection.cmdliner;
      fileutils = opamSelection.fileutils;
      jingoo = opamSelection.jingoo;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlify = opamSelection.ocamlify;
      opam-lib = opamSelection.opam-lib;
      re = opamSelection.re;
      uuidm = opamSelection.uuidm;
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
  name = "opam-build-revdeps-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "opam-build-revdeps";
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
    sha256 = "1lq7jvmjzv9h6s60qqq07vh5k3f5krzhfv4j13fi6cvwl2n681cz";
    url = "https://github.com/gildor478/opam-build-revdeps/releases/download/0.1.0/opam-build-revdeps-0.1.0.tar.gz";
  };
}

