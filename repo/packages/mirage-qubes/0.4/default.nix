world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      ipaddr = opamSelection.ipaddr or null;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-protocols-lwt = opamSelection.mirage-protocols-lwt or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      mirage-xen = opamSelection.mirage-xen;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      tcpip = opamSelection.tcpip or null;
      topkg = opamSelection.topkg;
      vchan = opamSelection.vchan;
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
  name = "mirage-qubes-0.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-qubes";
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
    sha256 = "13qaw8la5h8zqc7phns7g6d8i9ck9k6b2p32hp3xff991lg361nm";
    url = "http://github.com/mirage/mirage-qubes/releases/download/0.4/mirage-qubes-0.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

