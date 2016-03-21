world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libpam-dev or null) (pkgs.pam-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cdrom = opamSelection.cdrom;
      fd-send-recv = opamSelection.fd-send-recv;
      libvhd = opamSelection.libvhd;
      nbd = opamSelection.nbd;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      oclock = opamSelection.oclock;
      omake = opamSelection.omake;
      opasswd = opamSelection.opasswd;
      ounit = opamSelection.ounit;
      rpc = opamSelection.rpc;
      ssl = opamSelection.ssl;
      tar-format = opamSelection.tar-format;
      xapi-forkexecd = opamSelection.xapi-forkexecd;
      xapi-idl = opamSelection.xapi-idl;
      xapi-inventory = opamSelection.xapi-inventory;
      xapi-libs-transitional = opamSelection.xapi-libs-transitional;
      xapi-netdev = opamSelection.xapi-netdev;
      xapi-rrdd-plugin = opamSelection.xapi-rrdd-plugin;
      xapi-stdext = opamSelection.xapi-stdext;
      xapi-tapctl = opamSelection.xapi-tapctl;
      xen-api-client = opamSelection.xen-api-client;
      xenctrl = opamSelection.xenctrl;
      xenstore = opamSelection.xenstore;
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
  name = "xapi-1.9.56";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi";
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
    sha256 = "0gfbj04l6ydmqmbykbq37m5kcdrb4ga08rx7qsqrr5rbs338vqn5";
    url = "https://github.com/xapi-project/xen-api/archive/v1.9.56.tar.gz";
  };
}

