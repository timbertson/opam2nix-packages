world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring or null;
      cstruct = opamSelection.cstruct;
      cstruct-unix = opamSelection.cstruct-unix or null;
      lwt = opamSelection.lwt or null;
      mirage-clock = opamSelection.mirage-clock or null;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt or null;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt or null;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit or null;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ptime = opamSelection.ptime or null;
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
  name = "tls-0.9.1";
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
    sha256 = "0z80k8487pckmjhldnxxnyf0skbi3dcfd3wzlsfvmjnwp53hv7rg";
    url = "https://github.com/mirleft/ocaml-tls/releases/download/0.9.1/tls-0.9.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

