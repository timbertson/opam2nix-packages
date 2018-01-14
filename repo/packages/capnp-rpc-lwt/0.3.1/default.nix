world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      asetmap = opamSelection.asetmap;
      asn1-combinators = opamSelection.asn1-combinators;
      astring = opamSelection.astring;
      base64 = opamSelection.base64;
      capnp = opamSelection.capnp;
      capnp-rpc = opamSelection.capnp-rpc;
      conf-capnproto = opamSelection.conf-capnproto;
      fmt = opamSelection.fmt;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-clock = opamSelection.mirage-clock;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ptime = opamSelection.ptime;
      tls = opamSelection.tls;
      uri = opamSelection.uri;
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
  name = "capnp-rpc-lwt-0.3.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "capnp-rpc-lwt";
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
    sha256 = "0bs0ld9cm4hals5rqrgalmkj6aqbsrpa1nki0cmzfi9x9frgllc1";
    url = "https://github.com/mirage/capnp-rpc/releases/download/0.3.1/capnp-rpc-0.3.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

