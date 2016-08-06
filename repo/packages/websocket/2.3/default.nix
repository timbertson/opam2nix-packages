world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      async = opamSelection.async or null;
      async_ssl = opamSelection.async_ssl or null;
      cohttp = opamSelection.cohttp;
      conduit = opamSelection.conduit;
      containers = opamSelection.containers;
      cppo = opamSelection.cppo;
      cryptokit = opamSelection.cryptokit or null;
      lwt = opamSelection.lwt or null;
      nocrypto = opamSelection.nocrypto or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-endian = opamSelection.ocplib-endian;
      ppx_deriving = opamSelection.ppx_deriving;
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
  name = "websocket-2.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "websocket";
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
    sha256 = "10v12pwgf93a4w0zfsirx6szpprkshx05i1vy95cyg10cvha9l15";
    url = "https://github.com/vbmithr/ocaml-websocket/archive/2.3.tar.gz";
  };
}

