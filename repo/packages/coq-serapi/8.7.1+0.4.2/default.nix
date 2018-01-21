world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlp5 = opamSelection.camlp5;
      cmdliner = opamSelection.cmdliner;
      coq = opamSelection.coq;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_driver = opamSelection.ppx_driver;
      ppx_import = opamSelection.ppx_import;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      sexplib = opamSelection.sexplib;
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
  name = "coq-serapi-8.7.1+0.4.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "coq-serapi";
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
    sha256 = "1h6cx96iqcwnyw63hirb4xmcrr1792gqhkdr4jzjhywz755x5m2b";
    url = "https://github.com/ejgallego/coq-serapi/archive/8.7.1+0.4.2.tar.gz";
  };
}

