world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_core = opamSelection.ppx_core;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_driver = opamSelection.ppx_driver;
      ppx_tools = opamSelection.ppx_tools;
      ppx_type_conv = opamSelection.ppx_type_conv;
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
  name = "ppx_bin_prot-113.09.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_bin_prot";
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
    sha256 = "0cz9alf7sv23swp5wjsk137zv2ydq318ysnjzb4rv5irk3w115aa";
    url = "https://github.com/janestreet/ppx_bin_prot/archive/113.09.00.tar.gz";
  };
}

