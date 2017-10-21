world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libvirt or null) (pkgs.libvirt-bin or null)
        (pkgs.libvirt-dev or null) (pkgs.libxen-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest;
      camlp4 = opamSelection.camlp4;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      dns = opamSelection.dns;
      duration = opamSelection.duration;
      ezxmlm = opamSelection.ezxmlm;
      git = opamSelection.git;
      ipaddr = opamSelection.ipaddr;
      irmin = opamSelection.irmin;
      irmin-unix = opamSelection.irmin-unix;
      libvirt = opamSelection.libvirt;
      lwt = opamSelection.lwt;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt;
      mirage-profile = opamSelection.mirage-profile;
      mirage-stack-lwt = opamSelection.mirage-stack-lwt;
      mirage-time = opamSelection.mirage-time;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      uuidm = opamSelection.uuidm;
      vchan = opamSelection.vchan;
      xen-api-client = opamSelection.xen-api-client;
      xenctrl = opamSelection.xenctrl;
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
  name = "jitsu-0.2";
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
    sha256 = "0kqga5bcb2z80g4p51xjyqglx61hqr0728fkxwhzqq7imw7kisv6";
    url = "https://github.com/mirage/jitsu/archive/0.2.0.tar.gz";
  };
}

