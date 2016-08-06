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
      core_kernel = opamSelection.core_kernel;
      ctypes = opamSelection.ctypes;
      ctypes-foreign = opamSelection.ctypes-foreign;
      gnuplot = opamSelection.gnuplot or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "tensorflow-0.0.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "tensorflow";
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
    sha256 = "12gc770jpg9wm854l5kz7w40siydrpdmikxp6y41basnrklv8wv9";
    url = "https://github.com/LaurentMazare/tensorflow-ocaml/archive/0.0.5.tar.gz";
  };
}

