world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp = opamSelection.cohttp;
      fd-send-recv = opamSelection.fd-send-recv;
      libvirt = opamSelection.libvirt or null;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      oclock = opamSelection.oclock;
      ounit = opamSelection.ounit;
      qmp = opamSelection.qmp;
      re = opamSelection.re;
      rpc = opamSelection.rpc;
      sexplib = opamSelection.sexplib;
      uri = opamSelection.uri;
      uuidm = opamSelection.uuidm;
      uutf = opamSelection.uutf;
      xapi-forkexecd = opamSelection.xapi-forkexecd;
      xapi-idl = opamSelection.xapi-idl;
      xapi-inventory = opamSelection.xapi-inventory;
      xenctrl = opamSelection.xenctrl;
      xenstore = opamSelection.xenstore;
      xenstore_transport = opamSelection.xenstore_transport;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "xapi-xenopsd-0.9.44.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-xenopsd";
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
    sha256 = "05cdigkv5hk5z5q2i9dna8qvdcz8yiwhx31skh88c5dryqjjx9wr";
    url = "https://github.com/xapi-project/xenopsd/archive/v0.9.44.1.tar.gz";
  };
}

