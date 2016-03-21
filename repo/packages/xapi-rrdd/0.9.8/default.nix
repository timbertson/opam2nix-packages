world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      io-page = opamSelection.io-page;
      obuild = opamSelection.obuild;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      oclock = opamSelection.oclock;
      xapi-forkexecd = opamSelection.xapi-forkexecd;
      xapi-idl = opamSelection.xapi-idl;
      xapi-inventory = opamSelection.xapi-inventory;
      xapi-libs-transitional = opamSelection.xapi-libs-transitional;
      xapi-rrd-transport = opamSelection.xapi-rrd-transport;
      xapi-stdext = opamSelection.xapi-stdext;
      xapi-xenops = opamSelection.xapi-xenops;
      xen-gnt = opamSelection.xen-gnt;
      xenctrl = opamSelection.xenctrl;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "xapi-rrdd-0.9.8";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-rrdd";
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
    sha256 = "0sd8kd1ckvw2g0k3lz1fmcrbr13108pphsafnmvmzlaryfg95yw1";
    url = "https://github.com/xapi-project/xcp-rrdd/archive/v0.9.8.tar.gz";
  };
}

