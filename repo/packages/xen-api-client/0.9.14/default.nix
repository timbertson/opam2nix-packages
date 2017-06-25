world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      cohttp = opamSelection.cohttp;
      cstruct = opamSelection.cstruct;
      lwt = opamSelection.lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
      re = opamSelection.re;
      rpc = opamSelection.rpc;
      ssl = opamSelection.ssl;
      uri = opamSelection.uri;
      uuidm = opamSelection.uuidm;
      xapi-rrd = opamSelection.xapi-rrd;
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
  name = "xen-api-client-0.9.14";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xen-api-client";
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
    sha256 = "0mf15l54wql2yfa2zfvpynxrflmpvnks07zc6jqwb8mkhvpc30wh";
    url = "https://github.com/xapi-project/xen-api-client/archive/v0.9.14.tar.gz";
  };
}

