world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libxen-dev or null) (pkgs.uuid-dev or null)
        (pkgs.xen-devel or null) (pkgs.xen-dom0-libs-devel or null)
        (pkgs.xen-libs-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlp4 = opamSelection.camlp4;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      mirage-clock-unix = opamSelection.mirage-clock-unix;
      mirage-types = opamSelection.mirage-types;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      sexplib = opamSelection.sexplib;
      shared-memory-ring = opamSelection.shared-memory-ring;
      stringext = opamSelection.stringext;
      uri = opamSelection.uri;
      xen-evtchn = opamSelection.xen-evtchn;
      xen-gnt = opamSelection.xen-gnt;
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
  name = "xentropyd-0.9.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xentropyd";
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
    sha256 = "0sn9ys7zvw63m9sjp1m0cqx4cq6mcc5bvm0z1v5kxij80fa5jnny";
    url = "https://github.com/mirage/xentropyd/archive/v0.9.3.tar.gz";
  };
}

