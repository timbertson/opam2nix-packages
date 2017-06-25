world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      inotify = opamSelection.inotify;
      io-page = opamSelection.io-page;
      ocaml = opamSelection.ocaml;
      ocaml-systemd = opamSelection.ocaml-systemd;
      ocamlfind = opamSelection.ocamlfind;
      oclock = opamSelection.oclock;
      ounit = opamSelection.ounit;
      xapi-backtrace = opamSelection.xapi-backtrace;
      xapi-forkexecd = opamSelection.xapi-forkexecd;
      xapi-idl = opamSelection.xapi-idl;
      xapi-inventory = opamSelection.xapi-inventory;
      xapi-libs-transitional = opamSelection.xapi-libs-transitional;
      xapi-rrd-transport = opamSelection.xapi-rrd-transport;
      xapi-stdext = opamSelection.xapi-stdext;
      xapi-xenops = opamSelection.xapi-xenops;
      xen-gnt-unix = opamSelection.xen-gnt-unix;
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
  name = "xapi-rrdd-1.2.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "xapi-rrdd";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "031jv27vk5r46n14c56jjsk1ybb0fmc8x7i2dgb052h1yyx7cay6";
    url = "https://github.com/xapi-project/xcp-rrdd/archive/v1.2.1.tar.gz";
  };
}

