world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      bos = opamSelection.bos or null;
      ctypes = opamSelection.ctypes;
      ezjsonm = opamSelection.ezjsonm or null;
      fmt = opamSelection.fmt;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      rresult = opamSelection.rresult;
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
  name = "yaml-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "yaml";
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
    sha256 = "1f633fdiyx1gbh3k5nm45br85sxjzcagjh2ds2ga638h3xz9i2kb";
    url = "https://github.com/avsm/ocaml-yaml/releases/download/v0.1.0/yaml-0.1.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

