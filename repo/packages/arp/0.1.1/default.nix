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
      ipaddr = opamSelection.ipaddr;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt or null;
      mirage-types = opamSelection.mirage-types or null;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "arp-0.1.1";
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
    sha256 = "1l26hx02n1mw9kysyswgdjrbh88gmdykf22ci691p8pr88aliicy";
    url = "https://github.com/hannesm/arp/releases/download/0.1.1/arp-0.1.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

