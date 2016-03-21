world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlgraph = opamSelection.ocamlgraph;
      ounit = opamSelection.ounit or null;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_deriving_yojson = opamSelection.ppx_deriving_yojson;
      ppx_import = opamSelection.ppx_import;
      ppx_monadic = opamSelection.ppx_monadic;
      sedlex = opamSelection.sedlex;
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
  name = "modelica_ml-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "modelica_ml";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1i9rd291y82h4hz5ybgcx463lnzy6sbi9v9vzbha01pj9k0v7qvc";
    url = "https://github.com/choeger/modelica.ml/archive/v0.2.0.tar.gz";
  };
}

