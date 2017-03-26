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
      cppo = opamSelection.cppo;
      cryptokit = opamSelection.cryptokit or null;
      lwt = opamSelection.lwt or null;
      nocrypto = opamSelection.nocrypto or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-endian = opamSelection.ocplib-endian;
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
  name = "websocket-2.9";
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
    sha256 = "1hv0sby5n6psgzwlrj3n5f8kifv38fdfljpcfsyyy3agj3n3mxgw";
    url = "http://github.com/vbmithr/ocaml-websocket/archive/2.9.tar.gz";
  };
}

