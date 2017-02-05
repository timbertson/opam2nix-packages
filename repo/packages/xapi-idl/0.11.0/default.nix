world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      message-switch = opamSelection.message-switch;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      rpc = opamSelection.rpc;
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
  name = "xapi-idl-0.11.0";
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
    sha256 = "1i6bm6qk3yqlk2yyq106r128iby9961kfhr71aqq9b58db41z5wf";
    url = "https://github.com/xapi-project/xcp-idl/archive/v0.11.0.tar.gz";
  };
}

