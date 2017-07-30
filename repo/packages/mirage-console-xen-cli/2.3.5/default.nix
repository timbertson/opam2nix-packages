world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-console = opamSelection.mirage-console;
      mirage-console-lwt = opamSelection.mirage-console-lwt;
      mirage-console-unix = opamSelection.mirage-console-unix;
      mirage-console-xen-backend = opamSelection.mirage-console-xen-backend;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "mirage-console-xen-cli-2.3.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-console-xen-cli";
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
    sha256 = "0v9izq1crrwqc17x2hb6rqmr9742srj15sj5msdfq21ycf3l8pkg";
    url = "https://github.com/mirage/mirage-console/releases/download/v2.3.5/mirage-console-2.3.5.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

