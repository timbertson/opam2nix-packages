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
      io-page-xen = opamSelection.io-page-xen;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-block-lwt = opamSelection.mirage-block-lwt;
      mirage-xen = opamSelection.mirage-xen;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_tools = opamSelection.ppx_tools;
      rresult = opamSelection.rresult;
      shared-memory-ring-lwt = opamSelection.shared-memory-ring-lwt;
      stringext = opamSelection.stringext;
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
  name = "mirage-block-xen-1.5.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-block-xen";
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
    sha256 = "1awfk22wm70bidfqj1yz01qj45s6vilncbwlfswal3ayqh74q65g";
    url = "https://github.com/mirage/mirage-block-xen/releases/download/1.5.3/mirage-block-xen-1.5.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

