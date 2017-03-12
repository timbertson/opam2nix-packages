world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      lwt = opamSelection.lwt or null;
      mirage-clock = opamSelection.mirage-clock or null;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt or null;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt or null;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
      ptime = opamSelection.ptime;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
      topkg = opamSelection.topkg;
      x509 = opamSelection.x509;
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
  name = "tls-0.8.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "tls";
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
    sha256 = "1x6b96fkgj50ikijsivgiia4drm9nxx9mz1x5c8zrigiwkrgmljv";
    url = "http://github.com/mirleft/ocaml-tls/releases/download/0.8.0/tls-0.8.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

