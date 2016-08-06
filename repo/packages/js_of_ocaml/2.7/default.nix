world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-no-ppx = opamSelection.base-no-ppx or null;
      base-unix = opamSelection.base-unix;
      base64 = opamSelection.base64;
      camlp4 = opamSelection.camlp4;
      cmdliner = opamSelection.cmdliner;
      cppo = opamSelection.cppo;
      deriving = opamSelection.deriving or null;
      lwt = opamSelection.lwt;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving = opamSelection.ppx_deriving or null;
      ppx_tools = opamSelection.ppx_tools or null;
      reactiveData = opamSelection.reactiveData or null;
      tyxml = opamSelection.tyxml or null;
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
  name = "js_of_ocaml-2.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "js_of_ocaml";
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
    sha256 = "1dali1akyd4zmkwav0d957ynxq2jj6cc94r4xiaql7ca89ajz4jj";
    url = "https://github.com/ocsigen/js_of_ocaml/archive/2.7.tar.gz";
  };
}

