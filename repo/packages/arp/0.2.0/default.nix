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
      duration = opamSelection.duration or null;
      ipaddr = opamSelection.ipaddr;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt or null;
      mirage-clock = opamSelection.mirage-clock or null;
      mirage-protocols = opamSelection.mirage-protocols or null;
      mirage-protocols-lwt = opamSelection.mirage-protocols-lwt or null;
      mirage-time-lwt = opamSelection.mirage-time-lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_tools = opamSelection.ppx_tools;
      result = opamSelection.result;
      tcpip = opamSelection.tcpip or null;
      topkg = opamSelection.topkg;
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
  name = "arp-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "arp";
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
    sha256 = "02fbsihs3ns5zcijaqx104b50cx3d3g3sfnpqzqqa47p1gcwj8cp";
    url = "http://github.com/hannesm/arp/releases/download/0.2.0/arp-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

