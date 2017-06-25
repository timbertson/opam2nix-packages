world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      base-unix = opamSelection.base-unix;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      mirage-block-unix = opamSelection.mirage-block-unix;
      mtime = opamSelection.mtime;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      re = opamSelection.re;
      rpc = opamSelection.rpc;
      sexplib = opamSelection.sexplib;
      shared-block-ring = opamSelection.shared-block-ring;
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
  name = "message-switch-1.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "message-switch";
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
    sha256 = "0i7i0q23na0pakqmanijcky6kvx7z65w399czgwzpdrdmbp084hl";
    url = "https://github.com/xapi-project/message-switch/archive/v1.4.0.tar.gz";
  };
}

