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
      fd-send-recv = opamSelection.fd-send-recv;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocaml-systemd = opamSelection.ocaml-systemd;
      ocamlfind = opamSelection.ocamlfind;
      rpc = opamSelection.rpc;
      syslog = opamSelection.syslog;
      uuidm = opamSelection.uuidm;
      xapi-idl = opamSelection.xapi-idl;
      xapi-stdext = opamSelection.xapi-stdext;
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
  name = "xapi-forkexecd-1.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-forkexecd";
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
    sha256 = "0bfdl0svqnqi7v9qp22bv5nl9vfm8n794zmjxp9zsw0as5lki4aj";
    url = "https://github.com/xapi-project/forkexecd/archive/v1.4.0.tar.gz";
  };
}

