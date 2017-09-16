world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cpuid = opamSelection.cpuid;
      cstruct = opamSelection.cstruct;
      cstruct-lwt = opamSelection.cstruct-lwt;
      lwt = opamSelection.lwt;
      mirage-entropy = opamSelection.mirage-entropy or null;
      mirage-no-solo5 = opamSelection.mirage-no-solo5 or null;
      mirage-no-xen = opamSelection.mirage-no-xen or null;
      mirage-solo5 = opamSelection.mirage-solo5 or null;
      mirage-xen = opamSelection.mirage-xen or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocb-stubblr = opamSelection.ocb-stubblr;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      sexplib = opamSelection.sexplib;
      topkg = opamSelection.topkg;
      zarith = opamSelection.zarith;
      zarith-freestanding = opamSelection.zarith-freestanding or null;
      zarith-xen = opamSelection.zarith-xen or null;
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
  name = "nocrypto-0.5.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "nocrypto";
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
    sha256 = "0zshi9hlhcz61n5z1k6fx6rsi0pl4xgahsyl2jp0crqkaf3hqwlg";
    url = "https://github.com/mirleft/ocaml-nocrypto/releases/download/v0.5.4/nocrypto-0.5.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

