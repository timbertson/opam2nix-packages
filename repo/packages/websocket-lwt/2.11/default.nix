world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp-lwt-unix = opamSelection.cohttp-lwt-unix;
      ipaddr = opamSelection.ipaddr;
      lwt_ssl = opamSelection.lwt_ssl;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      websocket = opamSelection.websocket;
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
  name = "websocket-lwt-2.11";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "websocket-lwt";
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
    sha256 = "04jllympr5xy8yrg3cs4kinq2qpaiqgc3dl4g7dr3xr2nzjni07c";
    url = "https://github.com/vbmithr/ocaml-websocket/archive/2.11.tar.gz";
  };
}

