world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      dns = opamSelection.dns;
      ezxmlm = opamSelection.ezxmlm;
      git = opamSelection.git;
      ipaddr = opamSelection.ipaddr;
      irmin = opamSelection.irmin;
      irmin-unix = opamSelection.irmin-unix;
      libvirt = opamSelection.libvirt or null;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      uuidm = opamSelection.uuidm;
      vchan = opamSelection.vchan;
      xen-api-client = opamSelection.xen-api-client or null;
      xenctrl = opamSelection.xenctrl or null;
      xenstore = opamSelection.xenstore;
      xenstore_transport = opamSelection.xenstore_transport;
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
  name = "jitsu-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "jitsu";
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
    sha256 = "0fwq2fmvx5hh9bqvamnzv22mni14q5hbwqrr2dr7qlm7x63c6qia";
    url = "https://github.com/mirage/jitsu/archive/0.3.0.tar.gz";
  };
}

