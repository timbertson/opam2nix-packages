world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-threads = opamSelection.base-threads;
      base-unix = opamSelection.base-unix;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      fd-send-recv = opamSelection.fd-send-recv;
      lwt = opamSelection.lwt;
      message-switch = opamSelection.message-switch;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      re = opamSelection.re;
      rpc = opamSelection.rpc;
      sexplib = opamSelection.sexplib;
      uri = opamSelection.uri;
      xapi-backtrace = opamSelection.xapi-backtrace;
      xapi-inventory = opamSelection.xapi-inventory;
      xapi-rrd = opamSelection.xapi-rrd;
      xapi-stdext = opamSelection.xapi-stdext;
      xmlm = opamSelection.xmlm;
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
  name = "xapi-idl-1.14.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-idl";
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
    sha256 = "186r2amd4ic967yzd2ya2l8i2sx5jhnj4acpzajqlihq9782w082";
    url = "https://github.com/xapi-project/xcp-idl/archive/v1.14.0.tar.gz";
  };
}

